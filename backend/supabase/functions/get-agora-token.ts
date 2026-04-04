// ============================================================
// get-agora-token.ts
// ------------------------------------------------------------
// Xenia Edge Function: get-agora-token
//
// Manual Deployment:
// 1. Go to Supabase Dashboard -> Edge Functions -> "Create New Function"
// 2. Name it "get-agora-token"
// 3. Copy-paste this entire file into the editor.
// ============================================================

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { RtcTokenBuilder, RtcRole } from 'npm:agora-token'

const APP_ID = Deno.env.get('AGORA_APP_ID')
const APP_CERTIFICATE = Deno.env.get('AGORA_APP_CERTIFICATE')

serve(async (req: Request) => {
  const authHeader = req.headers.get('Authorization')
  if (!authHeader) return json({ error: 'Unauthorized' }, 401)

  // Verify inputs (channelName, uid)
  const { channelName, uid } = await req.json().catch(() => ({}))
  if (!channelName || !uid) return json({ error: 'Missing channelName or uid' }, 400)

  // Validate credentials
  if (!APP_ID || !APP_CERTIFICATE) {
    return json({ error: 'Agora credentials not set in Supabase secrets.' }, 500)
  }

  // Token settings
  const expirationTimeInSeconds = 3600 // 1 hour
  const currentTimestamp = Math.floor(Date.now() / 1000)
  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

  // Build Token
  const token = RtcTokenBuilder.buildTokenWithUid(
    APP_ID,
    APP_CERTIFICATE,
    channelName,
    uid,
    RtcRole.PUBLISHER, // All participants are publishers for video chat
    privilegeExpiredTs
  )

  return json({ token })
})

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  })
}
