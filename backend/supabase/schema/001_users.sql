-- ============================================================
-- 001_users.sql
-- ------------------------------------------------------------
-- Core user identity and metadata based on Xenia Tech Doc.
-- This table automatically mirrors auth.users.
-- ============================================================

-- Clean up existing types to prevent version conflicts
DROP TYPE IF EXISTS user_gender CASCADE;
DROP TYPE IF EXISTS user_badge CASCADE;
DROP TYPE IF EXISTS sub_type CASCADE;

-- Create enum for gender (Post-MVP but included in schema per doc)
CREATE TYPE user_gender AS ENUM ('male', 'female', 'other');


-- Create enum for quality badge (Post-MVP)
CREATE TYPE user_badge AS ENUM ('none', 'bronze', 'silver', 'gold');

-- Create enum for subscription (Post-MVP)
CREATE TYPE sub_type AS ENUM ('free', 'premium');

CREATE TABLE IF NOT EXISTS public.users (
  id                UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name      TEXT DEFAULT 'Anonymous Friend',
  age_confirmed     BOOLEAN DEFAULT FALSE,
  
  -- Vibe & Reputation (from Wireframes)
  reputation_score  DECIMAL(5,1) DEFAULT 100.0,
  quality_badge     user_badge DEFAULT 'none',
  
  -- Demographics & Meta
  gender            user_gender DEFAULT 'other',
  is_verified       BOOLEAN DEFAULT FALSE,
  is_banned         BOOLEAN DEFAULT FALSE,
  
  -- Internal Meta
  created_at        TIMESTAMPTZ DEFAULT now(),
  last_seen         TIMESTAMPTZ DEFAULT now()
);

-- Trigger to automatically create a user record on sign-up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, display_name)
  VALUES (NEW.id, 'New Friend');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
