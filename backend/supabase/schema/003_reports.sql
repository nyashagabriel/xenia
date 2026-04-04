-- ============================================================
-- 003_reports.sql
-- ------------------------------------------------------------
-- Safety and moderation tracking according to PDF Section 6.3.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.reports (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  reporter_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE SET NULL,
  reported_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  
  -- Context
  reason          TEXT,
  match_id        UUID, -- Optional reference to help review
  
  -- Review Meta
  created_at      TIMESTAMPTZ DEFAULT now(),
  reviewed        BOOLEAN DEFAULT FALSE,
  reviewer_note   TEXT
);

-- Index for moderator review view
CREATE INDEX idx_reports_pending ON public.reports (reviewed, created_at) WHERE reviewed = FALSE;
