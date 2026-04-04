-- 005_history.sql
-- Persistence for successful connections

CREATE TABLE IF NOT EXISTS public.matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_1_id UUID REFERENCES auth.users(id) NOT NULL,
    user_2_id UUID REFERENCES auth.users(id) NOT NULL,
    agora_channel TEXT NOT NULL,
    started_at TIMESTAMPTZ DEFAULT now(),
    ended_at TIMESTAMPTZ,
    duration_seconds INTEGER DEFAULT 0,
    
    -- Ensure user_1_id < user_2_id to prevent duplicate rows for the same pair
    CONSTRAINT unique_match_pair CHECK (user_1_id < user_2_id)
);

-- RLS Policies
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can see their own match history"
    ON public.matches FOR SELECT
    USING (auth.uid() = user_1_id OR auth.uid() = user_2_id);

-- Utility function to log a match end
CREATE OR REPLACE FUNCTION log_match_end(match_id UUID, duration INT)
RETURNS VOID AS $$
BEGIN
    UPDATE public.matches 
    SET ended_at = now(), duration_seconds = duration
    WHERE id = match_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
