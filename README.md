# A brief analysis on English Premier League 22-23 season
## Data Preparation
<p>Kaggle seems doesn't got a decent EPL player statistics so I'll rather check somewhere else.  Found <a href="https://www.whoscored.com/">Whoscores</a> with more comprehensive statistics, and data are from <a href="https://www.whoscored.com/StatisticsFeed/1/GetPlayerStatistics?category=summary&subcategory=offensive&statsAccumulationType=0&isCurrent=true&playerId=&teamIds=&matchId=&stageId=22076&tournamentOptions=2&sortBy=Rating&sortAscending=&age=&ageComparisonType=&appearances=&appearancesComparisonType=&field=Overall&nationality=&positionOptions=&timeOfTheGameEnd=&timeOfTheGameStart=&isMinApp=true&page=2&includeZeroValues=&numberOfPlayersToPick=10">an API</a>.  With some tweaks on the query string, I managed to grab all EPL players offensive, defensive and passing statistics for the season 22-23 in JSON files.  You could check it out in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/raw%20data">raw data</a> folder.</p>
<p>To import the data into PostgreSQL table, I used <a href="https://sqlizer.io/">SQLizer.IO</a> to convert the raw data into a runable SQL scripts.  Converted queries in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/tables">here</a> and it creates 3 separate tables: <code>whoscores_offensive</code>, <code>whoscores_defensive</code> and <code>whoscores_passing</code>.  However, to normalize the information, I've created 2 views <code>epl_player</code> and <code>epl_team</code>.  And I also need country code data to identify the players with a meaning name, another table <code>iso3166</code> was created as well as a country-country code lookup table.</p>

## Analysis
### Team player countries distribution
Players come and go every seasons and whether they come from different countries might influence team performance.  Let's take a look on each team player composition.

```sql
with player_by_country as (
	select distinct p.playerid
	,p.regioncode
	,t.teamname
	,i.country
	,i.continent
	from epl_player p
	join epl_team t on p.teamid = t.teamid
	join iso3166 i on p.regioncode = lower(i.code)
)

select count(distinct country) as no_of_countries
,count(distinct continent) as no_of_continents
,teamname
from player_by_country
group by teamname
order by no_of_countries desc, no_of_continents desc
```

```txt
no_of_countries  no_of_continents  teamname
---------------  ----------------  --------
17	          5                "Fulham"
17                4                "Tottenham"
17                3                "Chelsea"
15                5                "Leicester"
15                5                "Brighton"
14                4                "Wolves"
14                4                "Brentford"
14                4                "Nottingham Forest"
14                4                "Arsenal"
14                3                "Southampton"
14                3                "Everton"
14                3                "Liverpool"
13                3                "West Ham"
13                3                "Bournemouth"
13                2                "Leeds"
12                3                "Crystal Palace"
12                3                "Man City"
12                3                "Newcastle"
12                3                "Aston Villa"
12                2                "Man Utd"
```

### Average team age
Everyone know ManCity is the champion last season.  I want to know if player age have an impact on that with below query.  I included only team with average player age larger than all player average age.

```sql
select round(avg(p.age),2) as avg_age
,(select round(avg(age),2) as overall_avg_age from epl_player) as overall_avg_age
,t.teamname
from epl_player p
join epl_team t on p.teamid = t.teamid
group by teamname
having avg(p.age) > (select avg(age) as overall_avg_age from epl_player)
order by avg_age desc
```

```txt
avg_age  overall_avg_age  teamname
-------  ---------------  --------
28.04    26.43            "West Ham"
27.94    26.43            "Nottingham Forest"
27.73    26.43            "Aston Villa"
27.66    26.43            "Fulham"
27.48    26.43            "Newcastle"
26.73    26.43            "Crystal Palace"
26.73    26.43            "Man Utd"
26.64    26.43            "Leicester"
26.58    26.43            "Man City"
26.50    26.43            "Everton"
26.46    26.43            "Liverpool"
```

Interestingly, Man City is very close to the average player age.  West Ham got the highest average age.  It seems age doesn't play a very important factor. Younger player maybe better in fitness and/or workrate, but they might have less experiences.  Maybe Man City get a balance of both.

### Number of players with rating above average
Next, I want to see the number of player with rating above average in the whole EPL in each team.

```sql
select count(1) as above_avg_rating_cnt
, t.teamname 
from epl_player e
join epl_team t on t.teamid = e.teamid
where e.rating > (select avg(rating) from epl_player)
group by t.teamname
order by above_avg_rating_cnt desc
```

```txt
above_avg_rating_cnt	teamname
--------------------	--------
19			"Man City"
19			"Liverpool"
19			"Chelsea"
18			"Man Utd"
15			"Arsenal"
15			"Aston Villa"
14			"Newcastle"
14			"Everton"
14			"Brighton"
14			"Tottenham"
12			"Leicester"
12			"Crystal Palace"
11			"Southampton"
11			"West Ham"
10			"Brentford"
10			"Nottingham Forest"
10			"Bournemouth"
10			"Wolves"
10			"Fulham"
9			"Leeds"
```

Obviously the Big 6 are doing great and align with this.  However, relegated teams (Leicester and Southampton) should have done better with their player rating higher than many others.

### Best Forward of each team
Finally, let's see the best forward from each team rating and other offensive statistics.

```sql
select firstname
	, lastname
	, t.teamname
	, round(rating,2) rating
	, of_goal goal
	, of_assisttotal assist
	, round(of_shotspergame,2) spg
	, round(of_keypasspergame,2) kppg
from (
	select max(rating) as max_rating
		, teamid
	from epl_player
	where positiontext = 'Forward'
	group by teamid
	) bf
join epl_player p on bf.max_rating = p.rating
join epl_team t on p.teamid = t.teamid
order by rating desc
```

```txt
firstname		lastname			teamname		rating	goal	assist	spg	kppg
---------		--------			--------		------	----	------	---	----
"Erling"		"Haaland"			"Man City"		7.54	36	8	3.51	0.86
"Harry"			"Kane"				"Tottenham"		7.51	30	3	3.42	1.50
"Gabriel Fernando"	"de Jesus"			"Arsenal"		7.42	11	6	2.96	1.19
"Ivan"			"Toney"				"Brentford"		7.25	20	4	2.85	0.82
"Joelinton Cássio"	"Apolinário de Lira"		"Newcastle"		7.24	6	1	1.59	0.81
"Mohamed"		"Salah Hamed Mahrous Ghaly"	"Liverpool"		7.16	19	12	3.29	1.71
"Aleksandar"		"Mitrovic"			"Fulham"		7.08	14	1	3.88	0.67
"Marcus"		"Rashford"			"Man Utd"		7.08	17	5	3.09	0.86
"Dwight"		"McNeil"			"Everton"		6.99	7	3	1.28	1.36
"Leandro"		"Trossard"			"Brighton"		6.98	7	2	2.38	1.44
"Ollie"			"Watkins"			"Aston Villa"		6.96	15	6	2.32	0.84
"Wilfried"		"Zaha"				"Crystal Palace"	6.82	7	2	2.44	0.96
"Jarrod"		"Bowen"				"West Ham"		6.81	6	5	1.97	1.26
"Noni"			"Madueke"			"Chelsea"		6.80	1	0	1.00	1.08
"Dominic"		"Solanke"			"Bournemouth"		6.79	6	7	2.30	0.64
"Rodrigo"		"Moreno Machado"		"Leeds"			6.68	13	1	2.16	0.52
"Matheus"		"Santos Carneiro Da Cunha"	"Wolves"		6.63	2	0	1.53	0.41
"Ché"			"Adams"				"Southampton"		6.59	5	3	1.68	0.86
"Ayoze"			"Pérez"				"Leicester"		6.55	0	1	1.00	1.38
"Taiwo"			"Awoniyi"			"Nottingham Forest"	6.49	10	1	1.30	0.37
```

No doubt, Haaland statistic is extraordinary, with rating, goals and shots per game all above other teams forwards.  Salah done exceptional in assist among all forward and key pass per game.  Pérez, however, didn't doing very well and this maybe the reason why Leicester relegated.

<br><b>Data used:</b>
<br><a href="https://www.whoscored.com/Regions/252/Tournaments/2/Seasons/9075/Stages/20934/PlayerStatistics/England-Premier-League-2022-2023">Whoscores EPL players statistics</a>
<br><a href="https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes">ISO 3166 Country Code</a>
<br><b>Tools used:</b>
<br><a href="https://desktop.github.com/">GitHub Desktop v3.3.1</a>
<br><a href="https://www.postgresql.org/download/">PostgreSQL v16</a>
<br><a href="https://www.pgadmin.org/download/">pgAdmin 4 v7.6</a>
<br><a href="https://sqlizer.io/">SQLizer.IO</a>
