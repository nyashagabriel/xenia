# Xenia — Backend (Technical Documentation Alignment)

This folder contains the **single source of truth** for the Xenia backend, aligned with the 
`xenia_technical_doc.pdf` and high-fidelity wireframes.

---

## Directory Structure

```
backend/
├── README.md                  ← You are here
│
├── supabase/
│   ├── schema/                ← Migration files (run in orders 001-004)
│   │   ├── 001_users.sql      ← User identity (display_name, age_confirmed)
│   │   ├── 002_queue.sql      ← Matching states (waiting, matched)
│   │   ├── 003_reports.sql    ← Safety & moderation
│   │   └── 004_matching_rpc.sql ← Atomic claim_match() logic
│   │
│   ├── policies/
│   │   └── rls.sql            ← Row-Level Security
│   │
│   └── functions/             ← Standalone files for manual dashboard upload
│       └── get-agora-token.ts ← Generates Agora RTC tokens for sessions
│
├── docs/
│   ├── architecture.md        ← High-level system flow
│   └── agora_integration.md   ← Video SDK configuration & token logic
│
└── .env.example               ← Template for project secrets
```

---

## Technical Stack (MVP)

| Component | Technology | Description |
|-----------|------------|-------------|
| Backend   | Supabase   | Postgres + Auth + Realtime |
| Matching  | Supabase   | Client-driven via Realtime + Atomic RPC |
| Video     | Agora RTC  | Peer-to-peer media streams |
| Auth      | Supabase   | Anonymous/Google Auth |

---

## Deployment Logic

### 1. Database (SQL Editor)
Run the files in `supabase/schema/` in order (001 to 004) in your Supabase SQL Editor.
Then run `supabase/policies/rls.sql` to enable security.

### 2. Agora Tokens (Edge Functions)
Manual deployment:
1. Go to **Edge Functions** in your Supabase Dashboard.
2. Click **Create a new function** and name it `get-agora-token`.
3. Copy-paste the content of `supabase/functions/get-agora-token.ts` into the editor.
4. Set the following **Supabase Secrets**:
   - `AGORA_APP_ID`: Your App ID from Agora Console.
   - `AGORA_APP_CERTIFICATE`: Your App Certificate (required for tokens).
5. Click **Deploy**.

---

## Matching Flow (The "Real" Logic)

1. **Wait**: User A joins the queue (`INSERT INTO queue`).
2. **Listen**: Both clients subscribe to the `queue` table via **Supabase Realtime**.
3. **Claim**: When User B sees User A waiting, User B calls `rpc('claim_match', { target_user_id: A_ID })`.
4. **Matched**: If the RPC succeeds, both rows are updated to `matched` and share a common `agora_channel`.
5. **Token**: Both clients call the `get-agora-token` edge function and join the Agora channel.
