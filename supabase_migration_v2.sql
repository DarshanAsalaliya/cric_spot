-- ============================================================
-- CRIC SPOT — MIGRATION V2: Username, Player Identity, Tournaments
-- ============================================================
-- Run this AFTER supabase_setup.sql has been executed.
-- This adds username to profiles, user_id to players,
-- and creates views for player tournament lookups.
-- ============================================================


-- ============================================================
-- 1. ADD USERNAME TO PROFILES
-- ============================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS username TEXT UNIQUE;

-- Index for fast username lookups/search
CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles(username);


-- ============================================================
-- 2. ADD USER_ID TO PLAYERS (link player to auth user)
-- ============================================================
-- A player can optionally be linked to a real user account.
-- This lets users "claim" a player and see their career stats.
ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_players_user_id ON public.players(user_id);


-- ============================================================
-- 3. ADD TEAM_PLAYERS LINK TO TOURNAMENT (which team a player is in)
-- ============================================================
-- Already have team_players table. Add tournament context if needed.
-- Players in a tournament are simply players in teams that are in the tournament.


-- ============================================================
-- 4. VIEW: Get all tournaments a player is part of
-- ============================================================
CREATE OR REPLACE VIEW public.player_tournaments AS
SELECT DISTINCT
  tp.player_id,
  t.id AS tournament_id,
  t.name AS tournament_name,
  t.status AS tournament_status,
  t.start_date,
  t.end_date,
  tm.name AS team_name,
  tm.id AS team_id
FROM public.team_players tp
JOIN public.tournament_teams tt ON tt.team_id = tp.team_id
JOIN public.tournaments t ON t.id = tt.tournament_id
JOIN public.teams tm ON tm.id = tp.team_id;


-- ============================================================
-- 5. VIEW: Get career stats for a user (via their linked player)
-- ============================================================
CREATE OR REPLACE VIEW public.user_career_stats AS
SELECT
  p.user_id,
  p.id AS player_id,
  p.name AS player_name,
  p.total_matches,
  p.total_innings_batted,
  p.total_runs,
  p.total_balls_faced,
  p.total_fours,
  p.total_sixes,
  p.highest_score,
  p.total_innings_bowled,
  p.total_wickets,
  p.total_balls_bowled,
  p.total_runs_conceded,
  p.total_maidens,
  p.best_bowling_wickets,
  p.best_bowling_runs
FROM public.players p
WHERE p.user_id IS NOT NULL;


-- ============================================================
-- 6. FUNCTION: Search players by name (for tournament player picker)
-- ============================================================
CREATE OR REPLACE FUNCTION public.search_players(search_term TEXT)
RETURNS TABLE (
  id UUID,
  name TEXT,
  user_id UUID,
  username TEXT,
  total_matches INT,
  total_runs INT,
  total_wickets INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id,
    p.name,
    p.user_id,
    pr.username,
    p.total_matches,
    p.total_runs,
    p.total_wickets
  FROM public.players p
  LEFT JOIN public.profiles pr ON pr.id = p.user_id
  WHERE p.name ILIKE '%' || search_term || '%'
     OR pr.username ILIKE '%' || search_term || '%'
  ORDER BY p.total_matches DESC
  LIMIT 20;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- 7. FUNCTION: Link a player to a user account (claim player)
-- ============================================================
CREATE OR REPLACE FUNCTION public.claim_player(p_player_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE public.players
  SET user_id = auth.uid()
  WHERE id = p_player_id
    AND user_id IS NULL  -- only if not already claimed
    AND created_by = auth.uid();  -- only if they created it
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- 8. RLS FOR VIEWS (views inherit table RLS)
-- ============================================================
-- Views use the underlying table RLS, so no separate policies needed.


-- ============================================================
-- 9. UPDATE PROFILE TRIGGER TO INCLUDE USERNAME
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name, username)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
    NULL  -- user sets username later
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Note: The trigger already exists from v1, this just replaces the function body.


-- ============================================================
-- DONE! Migration V2 complete.
-- ============================================================


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- MIGRATION V3: Match Formats, Enhanced Player Stats
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Adds match_format to matches, enhanced career stats to players,
-- per-format stats table, and get_player_format_stats function.
-- Safe to run multiple times.
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-- ============================================================
-- V3-1. ADD MATCH FORMAT TO MATCHES
-- ============================================================
-- Format is auto-determined from overs:
-- 10 overs = t10, 20 overs = t20, 50 overs = odi, else = custom
ALTER TABLE public.matches
  ADD COLUMN IF NOT EXISTS match_format TEXT DEFAULT 'custom';

CREATE INDEX IF NOT EXISTS idx_matches_format ON public.matches(match_format);
CREATE INDEX IF NOT EXISTS idx_matches_tournament ON public.matches(tournament_id);


-- ============================================================
-- V3-2. ADD ENHANCED STATS TO PLAYERS
-- ============================================================
ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS total_not_outs INT DEFAULT 0;

ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS total_fifties INT DEFAULT 0;

ALTER TABLE public.players
  ADD COLUMN IF NOT EXISTS total_hundreds INT DEFAULT 0;


-- ============================================================
-- V3-3. PLAYER FORMAT STATS TABLE (per-format career stats)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.player_format_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  match_format TEXT NOT NULL,  -- 't10', 't20', 'odi', 'custom'
  -- Batting
  matches INT DEFAULT 0,
  innings_batted INT DEFAULT 0,
  runs INT DEFAULT 0,
  balls_faced INT DEFAULT 0,
  fours INT DEFAULT 0,
  sixes INT DEFAULT 0,
  highest_score INT DEFAULT 0,
  not_outs INT DEFAULT 0,
  fifties INT DEFAULT 0,
  hundreds INT DEFAULT 0,
  -- Bowling
  innings_bowled INT DEFAULT 0,
  wickets INT DEFAULT 0,
  balls_bowled INT DEFAULT 0,
  runs_conceded INT DEFAULT 0,
  maidens INT DEFAULT 0,
  best_bowling_wickets INT DEFAULT 0,
  best_bowling_runs INT DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(player_id, match_format)
);

-- RLS for player_format_stats
ALTER TABLE public.player_format_stats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Player format stats viewable by authenticated users"
  ON public.player_format_stats FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "System can manage player format stats"
  ON public.player_format_stats FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);


-- ============================================================
-- V3-4. FUNCTION: Determine match format from overs
-- ============================================================
CREATE OR REPLACE FUNCTION public.get_match_format(overs INT)
RETURNS TEXT AS $$
BEGIN
  IF overs = 10 THEN RETURN 't10';
  ELSIF overs <= 20 THEN RETURN 't20';
  ELSIF overs <= 50 THEN RETURN 'odi';
  ELSE RETURN 'custom';
  END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- ============================================================
-- V3-5. UPDATED: Career stats function (adds not_outs, 50s, 100s, format stats)
-- ============================================================
CREATE OR REPLACE FUNCTION public.update_player_career_stats(p_match_id UUID)
RETURNS VOID AS $$
DECLARE
  inning_rec RECORD;
  bat_rec RECORD;
  bowl_rec RECORD;
  v_format TEXT;
BEGIN
  -- Get match format
  SELECT match_format INTO v_format FROM public.matches WHERE id = p_match_id;
  IF v_format IS NULL THEN
    SELECT public.get_match_format(overs) INTO v_format FROM public.matches WHERE id = p_match_id;
    UPDATE public.matches SET match_format = v_format WHERE id = p_match_id;
  END IF;

  -- Loop through all innings of the match
  FOR inning_rec IN
    SELECT id FROM public.innings WHERE match_id = p_match_id
  LOOP
    -- Update batting stats
    FOR bat_rec IN
      SELECT * FROM public.batting_lineup WHERE inning_id = inning_rec.id AND player_id IS NOT NULL
    LOOP
      -- Update overall career stats
      UPDATE public.players SET
        total_innings_batted = total_innings_batted + 1,
        total_runs = total_runs + COALESCE(bat_rec.run, 0),
        total_balls_faced = total_balls_faced + COALESCE(bat_rec.ball, 0),
        total_fours = total_fours + COALESCE(bat_rec.four, 0),
        total_sixes = total_sixes + COALESCE(bat_rec.six, 0),
        highest_score = GREATEST(highest_score, COALESCE(bat_rec.run, 0)),
        total_not_outs = total_not_outs + CASE WHEN bat_rec.is_not_out THEN 1 ELSE 0 END,
        total_fifties = total_fifties + CASE WHEN COALESCE(bat_rec.run, 0) >= 50 AND COALESCE(bat_rec.run, 0) < 100 THEN 1 ELSE 0 END,
        total_hundreds = total_hundreds + CASE WHEN COALESCE(bat_rec.run, 0) >= 100 THEN 1 ELSE 0 END,
        updated_at = now()
      WHERE id = bat_rec.player_id;

      -- Upsert format-specific batting stats
      INSERT INTO public.player_format_stats (player_id, match_format, innings_batted, runs, balls_faced, fours, sixes, highest_score, not_outs, fifties, hundreds)
      VALUES (
        bat_rec.player_id, v_format, 1,
        COALESCE(bat_rec.run, 0), COALESCE(bat_rec.ball, 0),
        COALESCE(bat_rec.four, 0), COALESCE(bat_rec.six, 0),
        COALESCE(bat_rec.run, 0),
        CASE WHEN bat_rec.is_not_out THEN 1 ELSE 0 END,
        CASE WHEN COALESCE(bat_rec.run, 0) >= 50 AND COALESCE(bat_rec.run, 0) < 100 THEN 1 ELSE 0 END,
        CASE WHEN COALESCE(bat_rec.run, 0) >= 100 THEN 1 ELSE 0 END
      )
      ON CONFLICT (player_id, match_format) DO UPDATE SET
        innings_batted = player_format_stats.innings_batted + 1,
        runs = player_format_stats.runs + COALESCE(bat_rec.run, 0),
        balls_faced = player_format_stats.balls_faced + COALESCE(bat_rec.ball, 0),
        fours = player_format_stats.fours + COALESCE(bat_rec.four, 0),
        sixes = player_format_stats.sixes + COALESCE(bat_rec.six, 0),
        highest_score = GREATEST(player_format_stats.highest_score, COALESCE(bat_rec.run, 0)),
        not_outs = player_format_stats.not_outs + CASE WHEN bat_rec.is_not_out THEN 1 ELSE 0 END,
        fifties = player_format_stats.fifties + CASE WHEN COALESCE(bat_rec.run, 0) >= 50 AND COALESCE(bat_rec.run, 0) < 100 THEN 1 ELSE 0 END,
        hundreds = player_format_stats.hundreds + CASE WHEN COALESCE(bat_rec.run, 0) >= 100 THEN 1 ELSE 0 END,
        updated_at = now();
    END LOOP;

    -- Update bowling stats
    FOR bowl_rec IN
      SELECT * FROM public.bowling_lineup WHERE inning_id = inning_rec.id AND player_id IS NOT NULL
    LOOP
      -- Update overall career stats
      UPDATE public.players SET
        total_innings_bowled = total_innings_bowled + 1,
        total_wickets = total_wickets + COALESCE(bowl_rec.wicket, 0),
        total_balls_bowled = total_balls_bowled + COALESCE(bowl_rec.ball, 0),
        total_runs_conceded = total_runs_conceded + COALESCE(bowl_rec.run, 0),
        total_maidens = total_maidens + COALESCE(bowl_rec.maiden, 0),
        best_bowling_wickets = CASE
          WHEN COALESCE(bowl_rec.wicket, 0) > best_bowling_wickets THEN bowl_rec.wicket
          WHEN COALESCE(bowl_rec.wicket, 0) = best_bowling_wickets AND COALESCE(bowl_rec.run, 0) < best_bowling_runs THEN best_bowling_wickets
          ELSE best_bowling_wickets
        END,
        best_bowling_runs = CASE
          WHEN COALESCE(bowl_rec.wicket, 0) > best_bowling_wickets THEN bowl_rec.run
          WHEN COALESCE(bowl_rec.wicket, 0) = best_bowling_wickets AND COALESCE(bowl_rec.run, 0) < best_bowling_runs THEN bowl_rec.run
          ELSE best_bowling_runs
        END,
        updated_at = now()
      WHERE id = bowl_rec.player_id;

      -- Upsert format-specific bowling stats
      INSERT INTO public.player_format_stats (player_id, match_format, innings_bowled, wickets, balls_bowled, runs_conceded, maidens, best_bowling_wickets, best_bowling_runs)
      VALUES (
        bowl_rec.player_id, v_format, 1,
        COALESCE(bowl_rec.wicket, 0), COALESCE(bowl_rec.ball, 0),
        COALESCE(bowl_rec.run, 0), COALESCE(bowl_rec.maiden, 0),
        COALESCE(bowl_rec.wicket, 0), COALESCE(bowl_rec.run, 0)
      )
      ON CONFLICT (player_id, match_format) DO UPDATE SET
        innings_bowled = player_format_stats.innings_bowled + 1,
        wickets = player_format_stats.wickets + COALESCE(bowl_rec.wicket, 0),
        balls_bowled = player_format_stats.balls_bowled + COALESCE(bowl_rec.ball, 0),
        runs_conceded = player_format_stats.runs_conceded + COALESCE(bowl_rec.run, 0),
        maidens = player_format_stats.maidens + COALESCE(bowl_rec.maiden, 0),
        best_bowling_wickets = CASE
          WHEN COALESCE(bowl_rec.wicket, 0) > player_format_stats.best_bowling_wickets THEN bowl_rec.wicket
          ELSE player_format_stats.best_bowling_wickets
        END,
        best_bowling_runs = CASE
          WHEN COALESCE(bowl_rec.wicket, 0) > player_format_stats.best_bowling_wickets THEN bowl_rec.run
          ELSE player_format_stats.best_bowling_runs
        END,
        updated_at = now();
    END LOOP;
  END LOOP;

  -- Update total_matches for all players who participated
  UPDATE public.players SET
    total_matches = total_matches + 1,
    updated_at = now()
  WHERE id IN (
    SELECT DISTINCT player_id FROM public.batting_lineup
    WHERE inning_id IN (SELECT id FROM public.innings WHERE match_id = p_match_id)
    AND player_id IS NOT NULL
    UNION
    SELECT DISTINCT player_id FROM public.bowling_lineup
    WHERE inning_id IN (SELECT id FROM public.innings WHERE match_id = p_match_id)
    AND player_id IS NOT NULL
  );

  -- Update format matches count
  UPDATE public.player_format_stats SET
    matches = matches + 1,
    updated_at = now()
  WHERE player_id IN (
    SELECT DISTINCT player_id FROM public.batting_lineup
    WHERE inning_id IN (SELECT id FROM public.innings WHERE match_id = p_match_id)
    AND player_id IS NOT NULL
    UNION
    SELECT DISTINCT player_id FROM public.bowling_lineup
    WHERE inning_id IN (SELECT id FROM public.innings WHERE match_id = p_match_id)
    AND player_id IS NOT NULL
  ) AND match_format = v_format;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- V3-6. UPDATED user_career_stats VIEW (includes new fields)
-- ============================================================
-- Must DROP first because new columns change the view schema
DROP VIEW IF EXISTS public.user_career_stats;
CREATE VIEW public.user_career_stats AS
SELECT
  p.user_id,
  p.id AS player_id,
  p.name AS player_name,
  p.total_matches,
  p.total_innings_batted,
  p.total_runs,
  p.total_balls_faced,
  p.total_fours,
  p.total_sixes,
  p.highest_score,
  p.total_not_outs,
  p.total_fifties,
  p.total_hundreds,
  p.total_innings_bowled,
  p.total_wickets,
  p.total_balls_bowled,
  p.total_runs_conceded,
  p.total_maidens,
  p.best_bowling_wickets,
  p.best_bowling_runs
FROM public.players p
WHERE p.user_id IS NOT NULL;


-- ============================================================
-- V3-7. FUNCTION: Get format-specific stats for a player
-- ============================================================
CREATE OR REPLACE FUNCTION public.get_player_format_stats(p_player_id UUID)
RETURNS TABLE (
  match_format TEXT,
  matches INT,
  innings_batted INT,
  runs INT,
  balls_faced INT,
  fours INT,
  sixes INT,
  highest_score INT,
  not_outs INT,
  fifties INT,
  hundreds INT,
  innings_bowled INT,
  wickets INT,
  balls_bowled INT,
  runs_conceded INT,
  maidens INT,
  best_bowling_wickets INT,
  best_bowling_runs INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    pfs.match_format,
    pfs.matches,
    pfs.innings_batted,
    pfs.runs,
    pfs.balls_faced,
    pfs.fours,
    pfs.sixes,
    pfs.highest_score,
    pfs.not_outs,
    pfs.fifties,
    pfs.hundreds,
    pfs.innings_bowled,
    pfs.wickets,
    pfs.balls_bowled,
    pfs.runs_conceded,
    pfs.maidens,
    pfs.best_bowling_wickets,
    pfs.best_bowling_runs
  FROM public.player_format_stats pfs
  WHERE pfs.player_id = p_player_id
  ORDER BY pfs.matches DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- V3 DONE!
-- ============================================================
--
-- NEW IN V3:
-- - matches.match_format: t10/t20/odi/custom (auto from overs)
-- - players: total_not_outs, total_fifties, total_hundreds
-- - player_format_stats table: per-format career stats
-- - get_match_format() function: determines format from overs
-- - Updated update_player_career_stats(): handles 50s, 100s, not outs, format stats
-- - Updated user_career_stats view: includes new fields
-- - get_player_format_stats() function: get stats by format for a player
