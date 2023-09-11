--no. of players by team over average rating overall
select count(1) as above_avg_rating_cnt
, t.teamname 
from epl_player e
join epl_team t on t.teamid = e.teamid
where e.rating > (select avg(rating) from epl_player)
--and e.app > (select avg(app) from epl_player)
--and e.app > 1
group by t.teamname
order by above_avg_rating_cnt desc
--select app, avg(app),* from epl_player
--select avg(app) from epl_player
