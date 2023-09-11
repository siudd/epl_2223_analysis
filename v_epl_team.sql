-- View: public.epl_team

-- DROP VIEW public.epl_team;

CREATE OR REPLACE VIEW public.epl_team
 AS
 SELECT DISTINCT "playerTableStats_teamId" AS teamid,
    "playerTableStats_teamName" AS teamname
   FROM whoscore_defensive d
  WHERE "playerTableStats_teamId" IS NOT NULL;

ALTER TABLE public.epl_team
    OWNER TO postgres;

