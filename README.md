# A brief analysis on English Premier League 22-23 season
<h2>Data Preparation</h2>
<p></p>Kaggle seems doesn't got a decent EPL player statistics so I'll rather check somewhere else.  Found <a href="https://www.whoscored.com/">Whoscores</a> with more comprehensive statistics, and data are from <a href="https://www.whoscored.com/StatisticsFeed/1/GetPlayerStatistics?category=summary&subcategory=offensive&statsAccumulationType=0&isCurrent=true&playerId=&teamIds=&matchId=&stageId=22076&tournamentOptions=2&sortBy=Rating&sortAscending=&age=&ageComparisonType=&appearances=&appearancesComparisonType=&field=Overall&nationality=&positionOptions=&timeOfTheGameEnd=&timeOfTheGameStart=&isMinApp=true&page=2&includeZeroValues=&numberOfPlayersToPick=10">an API</a>.  With some tweaks on the query string, I managed to grab all EPL players offensive, defensive and passing statistics for the season 22-23 in JSON files.  You could check it out in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/raw%20data">raw data</a> folder.</p>
<p>To import the data into PostgreSQL table, I used <a href="https://sqlizer.io/">SQLizer.IO</a> to convert the raw data into a runable SQL scripts.  Converted queries in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/tables">here</a> and it creates 3 separate tables: <code>whoscores_offensive</code>, <code>whoscores_defensive</code> and <code>whoscores_passing</code>.  However, to normalize the information, I've created 2 views <code>epl_player</code> and <code>epl_team</code>.  And I also need country code data to identify the players with a meaning name, another table <code>iso3166</code> was created as well as a country-country code lookup table.</p>
<h2>Analysis</h2>
<h3>Average team age</h3>
<p>Everyone know ManCity is the champion last season.  I want to know if player age have an impact on that.  So I wrote below query</p>
<code>select round(avg(p.age),2) as avg_age
,(select round(avg(age),2) as overall_avg_age from epl_player) as overall_avg_age
,t.teamname
from epl_player p
join epl_team t on p.teamid = t.teamid
group by teamname
having avg(p.age) > (select avg(age) as overall_avg_age from epl_player)
order by avg_age desc</code>
<br><b>Data used:</b>
<br><a href="https://www.whoscored.com/Regions/252/Tournaments/2/Seasons/9075/Stages/20934/PlayerStatistics/England-Premier-League-2022-2023">Whoscores EPL players statistics</a>
<br><a href="https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes">ISO 3166 Country Code</a>
<br><b>Tools used:</b>
<br><a href="https://desktop.github.com/">GitHub Desktop v3.3.1</a>
<br><a href="https://www.postgresql.org/download/">PostgreSQL v16</a>
<br><a href="https://www.pgadmin.org/download/">pgAdmin 4 v7.6</a>
<br><a href="https://sqlizer.io/">SQLizer.IO</a>
