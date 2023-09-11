--average age of each team larger than overall average
select round(avg(p.age),2) as avg_age
,(select round(avg(age),2) as overall_avg_age from epl_player) as overall_avg_age
,t.teamname
from epl_player p
join epl_team t on p.teamid = t.teamid
group by teamname
having avg(p.age) > (select avg(age) as overall_avg_age from epl_player)
order by avg_age desc