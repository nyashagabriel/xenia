-- ============================================================
-- 004_matching_rpc.sql
-- ------------------------------------------------------------
-- Final matching logic: Atomic claim_match RPC according to PDF Section 5.2.
-- Runs with SECURITY DEFINER to handle atomic double-updates.
-- ============================================================

CREATE OR REPLACE FUNCTION public.claim_match(target_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    caller_id       UUID := auth.uid();
    new_channel_id  UUID := gen_random_uuid();
    caller_row_id   UUID;
    target_row_id   UUID;
    partner_name    TEXT;
    now_ts          TIMESTAMPTZ := now();
BEGIN
    -- 1. Identity Check
    IF caller_id IS NULL THEN
        RETURN jsonb_build_object('error', 'unauthorized', 'message', 'You must be signed in.');
    END IF;

    IF caller_id = target_user_id THEN
        RETURN jsonb_build_object('error', 'invalid_match', 'message', 'Cannot match with yourself.');
    END IF;

    -- 2. Transactional Claim with row locking (FOR UPDATE)
    -- Locate the caller's entry
    SELECT id INTO caller_row_id 
    FROM public.queue 
    WHERE user_id = caller_id AND status = 'waiting'
    FOR UPDATE;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'not_in_queue', 'message', 'Caller is not in the waiting queue.');
    END IF;

    -- Locate and lock the target's entry
    SELECT id INTO target_row_id 
    FROM public.queue 
    WHERE user_id = target_user_id AND status = 'waiting'
    FOR UPDATE SKIP LOCKED; -- Avoid deadlocks and race conditions

    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'match_unavailable', 'message', 'Target user is no longer waiting.');
    END IF;

    -- 3. Atomic Update
    -- Update the partner (the target)
    UPDATE public.queue
    SET status = 'matched',
        matched_with = caller_id,
        agora_channel = new_channel_id::TEXT,
        matched_at = now_ts
    WHERE id = target_row_id;
    
    -- Update the caller
    UPDATE public.queue
    SET status = 'matched',
        matched_with = target_user_id,
        agora_channel = new_channel_id::TEXT,
        matched_at = now_ts
    WHERE id = caller_row_id;

    -- 4. Get partner info for immediate UI update
    SELECT display_name INTO partner_name FROM public.users WHERE id = target_user_id;

    -- Use profiles to sync match count (wireframe quota logic)
    -- (TODO: Add daily quota reset logic here later)
    
    RETURN jsonb_build_object(
        'status', 'matched',
        'channel_name', new_channel_id::TEXT,
        'partner_id', target_user_id,
        'partner_name', partner_name
    );
END;
$$;
