--team composition by countries and continent
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