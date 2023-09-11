--average goals, assists and short per game by team
select round(avg(p.of_goal),2) as avg_goal
,round(avg(p.of_assisttotal),2) as avg_assist
,round(avg(p.of_shotspergame),2) as avg_spg
,t.teamname
from epl_player p
join epl_team t on p.teamid = t.teamid
group by t.teamname
order by avg_goal desc, avg_spg desc, avg_assist desc