# A brief analysis on English Premier League 22-23 season
## Data Preparation
<p>Kaggle seems doesn't got a decent EPL player statistics so I'll rather check somewhere else.  Found <a href="https://www.whoscored.com/">Whoscores</a> with more comprehensive statistics, and data are from <a href="https://www.whoscored.com/StatisticsFeed/1/GetPlayerStatistics?category=summary&subcategory=offensive&statsAccumulationType=0&isCurrent=true&playerId=&teamIds=&matchId=&stageId=22076&tournamentOptions=2&sortBy=Rating&sortAscending=&age=&ageComparisonType=&appearances=&appearancesComparisonType=&field=Overall&nationality=&positionOptions=&timeOfTheGameEnd=&timeOfTheGameStart=&isMinApp=true&page=2&includeZeroValues=&numberOfPlayersToPick=10">an API</a>.  With some tweaks on the query string, I managed to grab all EPL players offensive, defensive and passing statistics for the season 22-23 in JSON files.  You could check it out in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/raw%20data">raw data</a> folder.</p>
<p>To import the data into PostgreSQL table, I used <a href="https://sqlizer.io/">SQLizer.IO</a> to convert the raw data into a runable SQL scripts.  Converted queries in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/tables">here</a> and it creates 3 separate tables: <code>whoscores_offensive</code>, <code>whoscores_defensive</code> and <code>whoscores_passing</code>.  However, to normalize the information, I've created 2 views <code>epl_player</code> and <code>epl_team</code>.  And I also need country code data to identify the players with a meaning name, another table <code>iso3166</code> was created as well as a country-country code lookup table.</p>

## Analysis
### Team player countries distribution
Players come and go every seasons and the players from various countries might influence team performance.  Let's take a look on each team player composition.

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

Interestingly, Man City is very close to the average player age.  West Ham got the highest average age.  It seems age doesn't play a very important factor. Younger player be better fitness and/or workrate, but they might have less experiences.  Maybe Man City get a balance of both.
<br><b>Data used:</b>
<br><a href="https://www.whoscored.com/Regions/252/Tournaments/2/Seasons/9075/Stages/20934/PlayerStatistics/England-Premier-League-2022-2023">Whoscores EPL players statistics</a>
<br><a href="https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes">ISO 3166 Country Code</a>
<br><b>Tools used:</b>
<br><a href="https://desktop.github.com/">GitHub Desktop v3.3.1</a>
<br><a href="https://www.postgresql.org/download/">PostgreSQL v16</a>
<br><a href="https://www.pgadmin.org/download/">pgAdmin 4 v7.6</a>
<br><a href="https://sqlizer.io/">SQLizer.IO</a>
