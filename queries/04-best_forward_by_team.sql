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