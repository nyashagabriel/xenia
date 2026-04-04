-- ============================================================
-- rls.sql
-- ------------------------------------------------------------
-- Row-Level Security for Xenia (aligned with users/queue schemas)
-- ============================================================

-- Force RLS on all tables
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY; -- Temporary for setup
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- ── 1. USERS ──────────────────────────────────────────────────

-- Users can see their own profile
CREATE POLICY "Users can view own profile"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile (display_name, age_confirmed)
CREATE POLICY "Users can update own profile"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);

-- ── 2. QUEUE ──────────────────────────────────────────────────

-- Users can see their own queue entry AND their partner's entry (for Realtime)
CREATE POLICY "Users can view relevant queue entries"
  ON public.queue
  FOR SELECT
  USING (
    auth.uid() = user_id OR 
    auth.uid() = matched_with
  );

-- Users can INSERT their own queue entry (to start matching)
CREATE POLICY "Users can join queue"
  ON public.queue
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can DELETE their own queue entry (to leave queue)
CREATE POLICY "Users can leave queue"
  ON public.queue
  FOR DELETE
  USING (auth.uid() = user_id);

-- ── 3. REPORTS ────────────────────────────────────────────────

-- Any auth user can file a report
CREATE POLICY "Users can file reports"
  ON public.reports
  FOR INSERT
  WITH CHECK (auth.uid() = reporter_id);

-- Only founders/moderators can view reports (TODO: Add admin check)
CREATE POLICY "Only admins can view reports"
  ON public.reports
  FOR SELECT
  USING (FALSE); -- No one via standard REST
