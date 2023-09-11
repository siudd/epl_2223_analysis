# A brief analysis on English Premier League 22-23 season
<h2>Data Preparation</h2>
<p></p>Kaggle seems doesn't got a decent EPL player statistics so I'll rather check somewhere else.  Found <a href="https://www.whoscored.com/">Whoscores</a> with comprehensive statistics, and data are from <a href="https://www.whoscored.com/StatisticsFeed/1/GetPlayerStatistics?category=summary&subcategory=offensive&statsAccumulationType=0&isCurrent=true&playerId=&teamIds=&matchId=&stageId=22076&tournamentOptions=2&sortBy=Rating&sortAscending=&age=&ageComparisonType=&appearances=&appearancesComparisonType=&field=Overall&nationality=&positionOptions=&timeOfTheGameEnd=&timeOfTheGameStart=&isMinApp=true&page=2&includeZeroValues=&numberOfPlayersToPick=10">an API</a>.  With some tweaks on the query string, I managed to grab all EPL players offensive, defensive and passing statistics in a JSON file.  You could check it out in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/raw%20data">raw data</a> folder.</p>
<p>To import the data into PostgreSQL table, I used <a href="https://sqlizer.io/">SQLizer.IO</a> to convert the JSON data into a runable SQL scripts for that.  Converted queries in <a href="https://github.com/siudd/epl_2223_analysis/tree/main/queries">here</a> and it creates 3 separate tables: <code>whoscores_offensive</code>, <code>whoscores_defensive</code> and <code>whoscores_passing</code>.
</p>


<br><b>Data used:</b>
<br><a href="https://www.whoscored.com/Regions/252/Tournaments/2/Seasons/9075/Stages/20934/PlayerStatistics/England-Premier-League-2022-2023">Whoscores EPL players statistics</a>
<br><a href="https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes">ISO 3166 Country Code</a>
<br><b>Tools used:</b>
<br><a href="https://desktop.github.com/">GitHub Desktop v3.3.1</a>
<br><a href="https://www.postgresql.org/download/">PostgreSQL v16</a>
<br><a href="https://www.pgadmin.org/download/">pgAdmin 4 v7.6</a>
<br><a href="https://sqlizer.io/">SQLizer.IO</a>
