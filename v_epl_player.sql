-- View: public.epl_player

-- DROP VIEW public.epl_player;

CREATE OR REPLACE VIEW public.epl_player
 AS
 SELECT d."playerTableStats_firstName" AS firstname,
    d."playerTableStats_lastName" AS lastname,
    d."playerTableStats_playerId" AS playerid,
    d."playerTableStats_positionText" AS positiontext,
    d."playerTableStats_teamId" AS teamid,
    d."playerTableStats_seasonId" AS seasonid,
    d."playerTableStats_seasonName" AS seasonname,
    d."playerTableStats_isOpta" AS isopta,
    d."playerTableStats_height" AS height,
    d."playerTableStats_weight" AS weight,
    d."playerTableStats_age" AS age,
    d."playerTableStats_isManOfTheMatch" AS ismotm,
    d."playerTableStats_isActive" AS isactive,
    d."playerTableStats_playedPositions" AS playedpositions,
    d."playerTableStats_playedPositionsShort" AS playedpositionsshort,
    d."playerTableStats_regionCode" AS regioncode,
    d."playerTableStats_apps" AS app,
    d."playerTableStats_subOn" AS subon,
    d."playerTableStats_tacklePerGame" AS df_tacklepergame,
    d."playerTableStats_interceptionPerGame" AS df_interceptionpergame,
    d."playerTableStats_foulsPerGame" AS df_foulspergame,
    d."playerTableStats_offsideWonPerGame" AS df_offsidewonpergame,
    d."playerTableStats_clearancePerGame" AS df_clearancepergame,
    d."playerTableStats_wasDribbledPerGame" AS df_wasdribbledpergame,
    d."playerTableStats_outfielderBlockPerGame" AS df_outfielderblockpergame,
    o."playerTableStats_goal" AS of_goal,
    o."playerTableStats_assistTotal" AS of_assisttotal,
    o."playerTableStats_shotsPerGame" AS of_shotspergame,
    o."playerTableStats_keyPassPerGame" AS of_keypasspergame,
    o."playerTableStats_dribbleWonPerGame" AS of_dribblewonpergame,
    o."playerTableStats_foulGivenPerGame" AS of_foulgivenpergame,
    o."playerTableStats_offsideGivenPerGame" AS of_offsidegivenpergame,
    o."playerTableStats_dispossessedPerGame" AS of_dispossessedpergame,
    o."playerTableStats_turnoverPerGame" AS of_turnoverpergame,
    p."playerTableStats_assistTotal" AS ps_assisttotal,
    p."playerTableStats_keyPassPerGame" AS ps_keypasspergame,
    p."playerTableStats_totalPassesPerGame" AS ps_totalpassespergame,
    p."playerTableStats_accurateCrossesPerGame" AS ps_accuratecrossespergame,
    p."playerTableStats_accurateLongPassPerGame" AS ps_accuratelongpasspergame,
    p."playerTableStats_accurateThroughBallPerGame" AS ps_accuratethroughballpergame,
    d."playerTableStats_rating" AS rating,
    d."playerTableStats_minsPlayed" AS minsplayed,
    d."playerTableStats_goalOwn" AS goalown,
    d."playerTableStats_ranking" AS ranking
   FROM whoscore_defensive d,
    whoscore_offensive o,
    whoscore_passing p
  WHERE d."playerTableStats_playerId" = o."playerTableStats_playerId" AND d."playerTableStats_teamId" = o."playerTableStats_teamId" AND d."playerTableStats_playerId" = p."playerTableStats_playerId" AND d."playerTableStats_teamId" = p."playerTableStats_teamId" AND d."playerTableStats_playerId" IS NOT NULL AND o."playerTableStats_playerId" IS NOT NULL AND p."playerTableStats_playerId" IS NOT NULL
  ORDER BY d."playerTableStats_playerId";

ALTER TABLE public.epl_player
    OWNER TO postgres;

