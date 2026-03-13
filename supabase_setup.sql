-- ============================================================
-- CRIC SPOT — SUPABASE COMPLETE SETUP
-- ============================================================
-- Run this entire file in Supabase SQL Editor (Dashboard → SQL Editor → New Query)
-- This creates all tables, functions, triggers, RLS policies,
-- and enables Realtime.
-- ============================================================


-- ============================================================
-- 1. PROFILES TABLE (extends Supabase auth.users)
-- ============================================================
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  username TEXT UNIQUE,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index for fast username lookups/search
CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles(username);

-- Auto-create profile when a new user signs up
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

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
-- 2. TEAMS TABLE
-- ============================================================
CREATE TABLE public.teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  match_count INT DEFAULT 0,
  win INT DEFAULT 0,
  loss INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);


-- ============================================================
-- 3. PLAYERS TABLE (with career stats columns)
-- ============================================================
CREATE TABLE public.players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  -- Batting career stats
  total_matches INT DEFAULT 0,
  total_innings_batted INT DEFAULT 0,
  total_runs INT DEFAULT 0,
  total_balls_faced INT DEFAULT 0,
  total_fours INT DEFAULT 0,
  total_sixes INT DEFAULT 0,
  highest_score INT DEFAULT 0,
  -- Bowling career stats
  total_innings_bowled INT DEFAULT 0,
  total_wickets INT DEFAULT 0,
  total_balls_bowled INT DEFAULT 0,
  total_runs_conceded INT DEFAULT 0,
  total_maidens INT DEFAULT 0,
  best_bowling_wickets INT DEFAULT 0,
  best_bowling_runs INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_players_user_id ON public.players(user_id);


-- ============================================================
-- 4. TEAM_PLAYERS JUNCTION TABLE
-- ============================================================
CREATE TABLE public.team_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID NOT NULL REFERENCES public.teams(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(team_id, player_id)
);


-- ============================================================
-- 5. SHARE CODE GENERATOR FUNCTION
-- ============================================================
-- Generates a random 6-character uppercase alphanumeric code
CREATE OR REPLACE FUNCTION public.generate_share_code()
RETURNS TEXT AS $$
DECLARE
  chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result TEXT := '';
  i INT;
  code_exists BOOLEAN;
BEGIN
  LOOP
    result := '';
    FOR i IN 1..6 LOOP
      result := result || substr(chars, floor(random() * length(chars) + 1)::INT, 1);
    END LOOP;
    -- Check uniqueness
    SELECT EXISTS(SELECT 1 FROM public.matches WHERE share_code = result) INTO code_exists;
    EXIT WHEN NOT code_exists;
  END LOOP;
  RETURN result;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- 6. MATCHES TABLE
-- ============================================================
CREATE TABLE public.matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  share_code TEXT UNIQUE DEFAULT public.generate_share_code(),
  tournament_id UUID,  -- FK added after tournaments table is created

  -- Match config
  overs INT DEFAULT 20,
  player_per_match INT DEFAULT 11,
  is_wide_ball BOOLEAN DEFAULT TRUE,
  is_wide_reball BOOLEAN DEFAULT FALSE,
  wide_run INT DEFAULT 1,
  is_noball BOOLEAN DEFAULT TRUE,
  is_noball_reball BOOLEAN DEFAULT FALSE,
  noball_run INT DEFAULT 1,

  -- Toss
  toss_team_id UUID,
  toss_team_name TEXT,
  toss_elect TEXT,  -- 'bat' or 'field'

  -- Teams
  host_team_id UUID REFERENCES public.teams(id) ON DELETE SET NULL,
  visitor_team_id UUID REFERENCES public.teams(id) ON DELETE SET NULL,
  first_bat_team_name TEXT,
  second_bat_team_name TEXT,

  -- Live scores (summary for quick display)
  first_bat_team_score TEXT DEFAULT '0/0',
  first_bat_team_over TEXT DEFAULT '0.0',
  second_bat_team_score TEXT DEFAULT '0/0',
  second_bat_team_over TEXT DEFAULT '0.0',

  -- Result
  won_team_id UUID,
  won_team_name TEXT,
  won_by_description TEXT,

  -- Status: 'upcoming', 'live', 'completed'
  status TEXT DEFAULT 'upcoming',

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index for share code lookups (viewers joining via code)
CREATE INDEX idx_matches_share_code ON public.matches(share_code);
-- Index for user's matches
CREATE INDEX idx_matches_created_by ON public.matches(created_by);


-- ============================================================
-- 7. INNINGS TABLE
-- ============================================================
CREATE TABLE public.innings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id UUID NOT NULL REFERENCES public.matches(id) ON DELETE CASCADE,
  is_first_inning BOOLEAN DEFAULT TRUE,

  -- Teams
  bat_team_name TEXT,
  bowl_team_name TEXT,

  -- Aggregates
  total_run INT DEFAULT 0,
  total_wicket INT DEFAULT 0,
  total_ball INT DEFAULT 0,

  -- Extras
  extra_wide INT DEFAULT 0,
  extra_noball INT DEFAULT 0,
  extra_legbye INT DEFAULT 0,
  extra_bye INT DEFAULT 0,
  extra_penalty INT DEFAULT 0,
  extra_total INT DEFAULT 0,

  -- Ball-by-ball data (stored as JSONB arrays)
  current_over JSONB DEFAULT '[]'::JSONB,
  overs JSONB DEFAULT '[]'::JSONB,

  -- Fall of wicket log
  fall_of_wicket JSONB DEFAULT '[]'::JSONB,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index for match lookups
CREATE INDEX idx_innings_match_id ON public.innings(match_id);


-- ============================================================
-- 8. BATTING LINEUP TABLE
-- ============================================================
CREATE TABLE public.batting_lineup (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inning_id UUID NOT NULL REFERENCES public.innings(id) ON DELETE CASCADE,
  player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  name TEXT,
  run INT DEFAULT 0,
  ball INT DEFAULT 0,
  four INT DEFAULT 0,
  six INT DEFAULT 0,
  is_not_out BOOLEAN DEFAULT TRUE,
  out_by TEXT,
  out_type TEXT,
  helped_player TEXT,
  batting_order INT,  -- position in lineup (1, 2, 3...)
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_batting_lineup_inning ON public.batting_lineup(inning_id);


-- ============================================================
-- 9. BOWLING LINEUP TABLE
-- ============================================================
CREATE TABLE public.bowling_lineup (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inning_id UUID NOT NULL REFERENCES public.innings(id) ON DELETE CASCADE,
  player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  name TEXT,
  run INT DEFAULT 0,
  ball INT DEFAULT 0,
  wicket INT DEFAULT 0,
  maiden INT DEFAULT 0,
  bowling_order INT,  -- position in bowling order
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_bowling_lineup_inning ON public.bowling_lineup(inning_id);


-- ============================================================
-- 10. PARTNERSHIPS TABLE
-- ============================================================
CREATE TABLE public.partnerships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inning_id UUID NOT NULL REFERENCES public.innings(id) ON DELETE CASCADE,
  run INT DEFAULT 0,
  ball INT DEFAULT 0,
  extra INT DEFAULT 0,
  striker_player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  striker_name TEXT,
  striker_run INT DEFAULT 0,
  striker_ball INT DEFAULT 0,
  non_striker_player_id UUID REFERENCES public.players(id) ON DELETE SET NULL,
  non_striker_name TEXT,
  non_striker_run INT DEFAULT 0,
  non_striker_ball INT DEFAULT 0,
  partnership_order INT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_partnerships_inning ON public.partnerships(inning_id);


-- ============================================================
-- 11. TOURNAMENTS TABLE
-- ============================================================
CREATE TABLE public.tournaments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  start_date DATE,
  end_date DATE,
  -- Status: 'upcoming', 'in_progress', 'completed'
  status TEXT DEFAULT 'upcoming',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_tournaments_created_by ON public.tournaments(created_by);


-- ============================================================
-- 12. TOURNAMENT_TEAMS JUNCTION TABLE
-- ============================================================
CREATE TABLE public.tournament_teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id UUID NOT NULL REFERENCES public.tournaments(id) ON DELETE CASCADE,
  team_id UUID NOT NULL REFERENCES public.teams(id) ON DELETE CASCADE,
  played INT DEFAULT 0,
  won INT DEFAULT 0,
  lost INT DEFAULT 0,
  no_result INT DEFAULT 0,
  points INT DEFAULT 0,
  net_run_rate NUMERIC(6,3) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tournament_id, team_id)
);


-- ============================================================
-- 13. ADD FOREIGN KEY: matches.tournament_id → tournaments
-- ============================================================
ALTER TABLE public.matches
  ADD CONSTRAINT fk_matches_tournament
  FOREIGN KEY (tournament_id)
  REFERENCES public.tournaments(id)
  ON DELETE SET NULL;


-- ============================================================
-- 14. UPDATED_AT AUTO-UPDATE TRIGGER
-- ============================================================
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.teams
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.players
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.matches
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.innings
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.tournaments
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


-- ============================================================
-- 15. CAREER STATS UPDATE FUNCTION
-- ============================================================
-- Call this after a match is completed to update player career stats.
-- It reads batting_lineup and bowling_lineup from all innings of a match.
CREATE OR REPLACE FUNCTION public.update_player_career_stats(p_match_id UUID)
RETURNS VOID AS $$
DECLARE
  inning_rec RECORD;
  bat_rec RECORD;
  bowl_rec RECORD;
BEGIN
  -- Loop through all innings of the match
  FOR inning_rec IN
    SELECT id FROM public.innings WHERE match_id = p_match_id
  LOOP
    -- Update batting stats
    FOR bat_rec IN
      SELECT * FROM public.batting_lineup WHERE inning_id = inning_rec.id AND player_id IS NOT NULL
    LOOP
      UPDATE public.players SET
        total_matches = total_matches,  -- handled separately below
        total_innings_batted = total_innings_batted + 1,
        total_runs = total_runs + COALESCE(bat_rec.run, 0),
        total_balls_faced = total_balls_faced + COALESCE(bat_rec.ball, 0),
        total_fours = total_fours + COALESCE(bat_rec.four, 0),
        total_sixes = total_sixes + COALESCE(bat_rec.six, 0),
        highest_score = GREATEST(highest_score, COALESCE(bat_rec.run, 0)),
        updated_at = now()
      WHERE id = bat_rec.player_id;
    END LOOP;

    -- Update bowling stats
    FOR bowl_rec IN
      SELECT * FROM public.bowling_lineup WHERE inning_id = inning_rec.id AND player_id IS NOT NULL
    LOOP
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
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- 16. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.innings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.batting_lineup ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bowling_lineup ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.partnerships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tournament_teams ENABLE ROW LEVEL SECURITY;

-- -------------------------------------------------------
-- PROFILES
-- -------------------------------------------------------
-- Anyone can read profiles (for displaying player names)
CREATE POLICY "Profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

-- Users can update only their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- -------------------------------------------------------
-- TEAMS
-- -------------------------------------------------------
-- Authenticated users can read all teams
CREATE POLICY "Teams are viewable by authenticated users"
  ON public.teams FOR SELECT
  TO authenticated
  USING (true);

-- Users can insert teams
CREATE POLICY "Users can create teams"
  ON public.teams FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Users can update/delete their own teams
CREATE POLICY "Users can update own teams"
  ON public.teams FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can delete own teams"
  ON public.teams FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);

-- -------------------------------------------------------
-- PLAYERS
-- -------------------------------------------------------
-- Anyone authenticated can read players (for profile viewing)
CREATE POLICY "Players are viewable by authenticated users"
  ON public.players FOR SELECT
  TO authenticated
  USING (true);

-- Users can create players
CREATE POLICY "Users can create players"
  ON public.players FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Users can update their own players
CREATE POLICY "Users can update own players"
  ON public.players FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

-- -------------------------------------------------------
-- TEAM_PLAYERS
-- -------------------------------------------------------
CREATE POLICY "Team players viewable by authenticated users"
  ON public.team_players FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Team owner can manage team players"
  ON public.team_players FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.teams WHERE id = team_id AND created_by = auth.uid())
  );

CREATE POLICY "Team owner can remove team players"
  ON public.team_players FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.teams WHERE id = team_id AND created_by = auth.uid())
  );

-- -------------------------------------------------------
-- MATCHES
-- -------------------------------------------------------
-- Match creator can do everything with their matches
CREATE POLICY "Users can create matches"
  ON public.matches FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own matches"
  ON public.matches FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can delete own matches"
  ON public.matches FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);

-- ANYONE (including anonymous) can view matches — needed for live score viewers
CREATE POLICY "Matches are viewable by everyone"
  ON public.matches FOR SELECT
  USING (true);

-- -------------------------------------------------------
-- INNINGS
-- -------------------------------------------------------
-- Anyone can view innings (for live score viewers)
CREATE POLICY "Innings are viewable by everyone"
  ON public.innings FOR SELECT
  USING (true);

-- Match creator can insert/update innings
CREATE POLICY "Match creator can insert innings"
  ON public.innings FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.matches WHERE id = match_id AND created_by = auth.uid())
  );

CREATE POLICY "Match creator can update innings"
  ON public.innings FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.matches WHERE id = match_id AND created_by = auth.uid())
  );

-- -------------------------------------------------------
-- BATTING LINEUP
-- -------------------------------------------------------
CREATE POLICY "Batting lineup viewable by everyone"
  ON public.batting_lineup FOR SELECT
  USING (true);

CREATE POLICY "Match creator can insert batting lineup"
  ON public.batting_lineup FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.innings i
      JOIN public.matches m ON m.id = i.match_id
      WHERE i.id = inning_id AND m.created_by = auth.uid()
    )
  );

CREATE POLICY "Match creator can update batting lineup"
  ON public.batting_lineup FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.innings i
      JOIN public.matches m ON m.id = i.match_id
      WHERE i.id = inning_id AND m.created_by = auth.uid()
    )
  );

-- -------------------------------------------------------
-- BOWLING LINEUP
-- -------------------------------------------------------
CREATE POLICY "Bowling lineup viewable by everyone"
  ON public.bowling_lineup FOR SELECT
  USING (true);

CREATE POLICY "Match creator can insert bowling lineup"
  ON public.bowling_lineup FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.innings i
      JOIN public.matches m ON m.id = i.match_id
      WHERE i.id = inning_id AND m.created_by = auth.uid()
    )
  );

CREATE POLICY "Match creator can update bowling lineup"
  ON public.bowling_lineup FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.innings i
      JOIN public.matches m ON m.id = i.match_id
      WHERE i.id = inning_id AND m.created_by = auth.uid()
    )
  );

-- -------------------------------------------------------
-- PARTNERSHIPS
-- -------------------------------------------------------
CREATE POLICY "Partnerships viewable by everyone"
  ON public.partnerships FOR SELECT
  USING (true);

CREATE POLICY "Match creator can insert partnerships"
  ON public.partnerships FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.innings i
      JOIN public.matches m ON m.id = i.match_id
      WHERE i.id = inning_id AND m.created_by = auth.uid()
    )
  );

CREATE POLICY "Match creator can update partnerships"
  ON public.partnerships FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.innings i
      JOIN public.matches m ON m.id = i.match_id
      WHERE i.id = inning_id AND m.created_by = auth.uid()
    )
  );

-- -------------------------------------------------------
-- TOURNAMENTS
-- -------------------------------------------------------
-- Anyone authenticated can view tournaments
CREATE POLICY "Tournaments viewable by authenticated users"
  ON public.tournaments FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create tournaments"
  ON public.tournaments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own tournaments"
  ON public.tournaments FOR UPDATE
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can delete own tournaments"
  ON public.tournaments FOR DELETE
  TO authenticated
  USING (auth.uid() = created_by);

-- -------------------------------------------------------
-- TOURNAMENT_TEAMS
-- -------------------------------------------------------
CREATE POLICY "Tournament teams viewable by authenticated users"
  ON public.tournament_teams FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Tournament creator can manage teams"
  ON public.tournament_teams FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.tournaments WHERE id = tournament_id AND created_by = auth.uid())
  );

CREATE POLICY "Tournament creator can remove teams"
  ON public.tournament_teams FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.tournaments WHERE id = tournament_id AND created_by = auth.uid())
  );

CREATE POLICY "Tournament creator can update teams"
  ON public.tournament_teams FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.tournaments WHERE id = tournament_id AND created_by = auth.uid())
  );


-- ============================================================
-- 17. ENABLE REALTIME
-- ============================================================
-- Enable Realtime for matches and innings tables (live score viewers)
ALTER PUBLICATION supabase_realtime ADD TABLE public.matches;
ALTER PUBLICATION supabase_realtime ADD TABLE public.innings;


-- ============================================================
-- 18. STORAGE BUCKET (for profile photos - optional)
-- ============================================================
-- Run this separately if you want avatar uploads:
--
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('avatars', 'avatars', true);
--
-- CREATE POLICY "Avatar images are publicly accessible"
--   ON storage.objects FOR SELECT
--   USING (bucket_id = 'avatars');
--
-- CREATE POLICY "Users can upload their own avatar"
--   ON storage.objects FOR INSERT
--   TO authenticated
--   WITH CHECK (
--     bucket_id = 'avatars' AND
--     (storage.foldername(name))[1] = auth.uid()::text
--   );
--
-- CREATE POLICY "Users can update their own avatar"
--   ON storage.objects FOR UPDATE
--   TO authenticated
--   USING (
--     bucket_id = 'avatars' AND
--     (storage.foldername(name))[1] = auth.uid()::text
--   );


-- ============================================================
-- 19. VIEWS: Player Tournaments & User Career Stats
-- ============================================================

-- View: Get all tournaments a player is part of
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

-- View: Get career stats for a user (via their linked player)
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
-- 20. FUNCTION: Search players by name or username
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
-- 21. FUNCTION: Link a player to a user account (claim player)
-- ============================================================
CREATE OR REPLACE FUNCTION public.claim_player(p_player_id UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE public.players
  SET user_id = auth.uid()
  WHERE id = p_player_id
    AND user_id IS NULL
    AND created_by = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================
-- DONE! SETUP COMPLETE.
-- ============================================================
--
-- AFTER RUNNING THIS SQL:
--
-- 1. Go to Supabase Dashboard → Authentication → Providers
--    - Enable "Email" provider (already enabled by default)
--    - Enable "Google" provider (add your Google OAuth credentials)
--
-- 2. Go to Settings → API to get your:
--    - Project URL  (use as SUPABASE_URL)
--    - anon/public key  (use as SUPABASE_ANON_KEY)
--
-- 3. Run your Flutter app with:
--    flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
--
-- 4. To update player career stats after a match completes, call:
--    SELECT public.update_player_career_stats('match-uuid-here');
--    (This is called from the Flutter app via Supabase RPC)
--
-- TABLE SUMMARY:
-- ┌─────────────────────┬────────────────────────────────────────────┐
-- │ Table               │ Purpose                                    │
-- ├─────────────────────┼────────────────────────────────────────────┤
-- │ profiles            │ User profile (auto-created on signup)       │
-- │ teams               │ Cricket teams                              │
-- │ players             │ Players with career stats                  │
-- │ team_players        │ Team ↔ Player junction                     │
-- │ matches             │ Match config, scores, share code           │
-- │ innings             │ Inning data, extras, ball-by-ball          │
-- │ batting_lineup      │ Per-inning batting scorecard               │
-- │ bowling_lineup      │ Per-inning bowling figures                 │
-- │ partnerships        │ Batting partnerships per inning            │
-- │ tournaments         │ Tournament info                            │
-- │ tournament_teams    │ Tournament ↔ Team with points table        │
-- └─────────────────────┴────────────────────────────────────────────┘
--
-- RLS SUMMARY:
-- - matches & innings: Public read (for live score viewers), write by creator
-- - teams, players, tournaments: Read by authenticated, write by creator
-- - batting/bowling/partnerships: Public read, write by match creator
-- - profiles: Public read, update by self
--
-- REALTIME:
-- - matches and innings tables have Realtime enabled
-- - Viewers subscribe via share_code → match_id → stream updates
