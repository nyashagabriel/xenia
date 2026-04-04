# Xenia — Backend Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────┐
│                     XENIA CLIENT                        │
│              (Flutter Web + Mobile App)                  │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐  │
│  │ Auth     │  │ Queue    │  │ WebRTC   │  │ UI     │  │
│  │ Service  │  │ Service  │  │ Service  │  │ Layer  │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────────┘  │
└───────┼─────────────┼─────────────┼────────────────────-┘
        │             │             │
        ▼             ▼             │
┌───────────────────────────────┐   │
│        SUPABASE               │   │
│                               │   │
│  ┌──────────┐  ┌───────────┐  │   │  P2P Video
│  │ Auth     │  │ Realtime  │  │   │  (after signaling)
│  │ (OAuth)  │  │ (CDC)     │  │   │
│  └──────────┘  └─────┬─────┘  │   │
│                      │        │   │
│  ┌───────────────────┼──────┐ │   │
│  │   PostgreSQL       │      │ │   │
│  │                   │      │ │   │
│  │  profiles ◄───────┘      │ │   │
│  │  match_queue (signaling) │ │   │
│  │  match_history           │ │   │
│  │  user_reports            │ │   │
│  └──────────────────────────┘ │   │
│                               │   │
│  ┌────────────────────────┐   │   │
│  │   Edge Functions (Deno)│   │   │
│  │   join-queue           │   │   │
│  │   skip-match           │   │   │
│  │   report-user          │   │   │
│  └────────────────────────┘   │   │
└───────────────────────────────┘   │
                                    │
                           ┌────────┴────────┐
                           │  STUN / TURN    │
                           │  (Metered.ca)   │
                           └─────────────────┘
```

---

## Authentication Flow

```
User opens app
     │
     ▼
Supabase Auth (Google/Apple OAuth)
     │
     ▼
auth.users record created automatically
     │
     ▼  (trigger: on_auth_user_created)
public.profiles record auto-created
     │
     ▼
Flutter receives session (JWT)
     ├── All edge function calls use this JWT in Authorization header
     └── Supabase client auto-refreshes the token
```

---

## Data Flow: Matching

```
Tap MATCH
    │
    ▼
POST /functions/v1/join-queue  (with JWT)
    │
    ├── Banned? → return 403
    ├── Over daily limit? → return 429 (with recharges_at timestamp)
    │
    ├── Partner available?
    │    ├── YES → update both rows to 'matched'
    │    │         Realtime fires on both clients
    │    │         → WebRTC signaling begins (see signaling.md)
    │    └── NO  → insert own row as 'searching'
    │              Flutter polls via Realtime subscription
    │
    ▼
[Live call active — P2P, Supabase not involved in media]
    │
    ├── SKIP → POST /functions/v1/skip-match
    └── FLAG → POST /functions/v1/report-user
```

---

## Security Model

| Layer | Mechanism |
|-------|-----------|
| Auth | Supabase Auth JWT — mandatory on all requests |
| DB access | Row-Level Security (see `policies/rls.sql`) |
| Edge functions | Service role key (bypasses RLS — runs as trusted server) |
| Bans | `is_banned` on profile — checked first in every edge function |
| Device bans | `reported_device_fingerprint` on `user_reports` (future: checked at sign-up) |
| Reputation | Decremented automatically on report; auto-ban below threshold |

---

## Environment Variables

| Key | Where used |
|-----|-----------|
| `SUPABASE_URL` | All edge functions + Flutter client |
| `SUPABASE_ANON_KEY` | Flutter client (public, safe to embed) |
| `SUPABASE_SERVICE_ROLE_KEY` | Edge functions only — NEVER in Flutter |
| `TURN_URL` | Flutter WebRTC config (loaded from edge function or secure storage) |
| `TURN_USERNAME` | Flutter WebRTC config |
| `TURN_CREDENTIAL` | Flutter WebRTC config |

> See `.env.example` for the template.
