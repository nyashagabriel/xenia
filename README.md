# Xenia

> *Xenia — the ancient practice of hospitality between strangers.*

A stress-release video chat for Gen Z. One button. One stranger. One real conversation.

---

## What is Xenia

Random video calls are not a new idea. But every existing platform gets the same thing wrong — broken matching, the wrong people, no soul. Your classmates used those broken apps anyway because the need is real: sometimes you just want to talk to a stranger and decompress.

Xenia is built on that observation. Not on a feature list.

The core loop is simple. You open the app, tap one button, get matched with a stranger, talk, skip when you are done. That is it for v1. No filters yet. No games. No premium tier. Just the raw experience working properly so we can learn what people actually want before we build on top of it.

---

## The name

Xenia (ξενία) is a Greek concept — the sacred bond of hospitality between host and stranger. You treat the unknown person well, not because you know them, but because that is the standard.

That is the product philosophy in one word.

---

## MVP Scope

What is in v1:

- One-tap matching queue
- Peer-to-peer video call via Daily.co
- Skip to next match
- Report button
- Basic user profile (age, display name)

What is not in v1:

- Gender or interest filters
- Translation
- Icebreaker games
- Premium tier
- Verification shield

These are real features. They come after we learn from real users. Not before.

---

## Stack

| Layer | Tool | Why |
|---|---|---|
| App | Flutter | We know it. Full control. |
| Video | Daily.co | Handles WebRTC, STUN, TURN. No custom backend needed. Free tier. |
| Queue + Profiles | Supabase | We know it. Realtime built in. Free tier. |
| Auth | Supabase Auth | Already in the stack. |

No custom backend. No Docker. No AWS. No second database.

---

## How matching works

1. User taps the button
2. Their record is inserted into the `queue` table in Supabase with status `waiting`
3. Supabase Realtime fires when two users are waiting
4. The app pairs them, calls Daily.co to create a room
5. Both users receive the room token and connect
6. On skip or call end — the cycle resets

The signalling is handled by Daily.co. Supabase handles the queue state. Flutter handles the UI. No server process we need to babysit.

---

## Project structure

```
xenia/
├── lib/
│   ├── core/           # constants, theme, router
│   ├── models/         # user, session
│   ├── services/       # supabase, daily_co, queue
│   ├── pages/          # splash, home, call, profile
│   └── main.dart
├── supabase/
│   └── migrations/     # queue table, profiles table
└── README.md
```

---

## Database

```sql
-- Profiles
create table profiles (
  id uuid primary key references auth.users,
  display_name text not null,
  age int,
  created_at timestamptz default now()
);

-- Matching queue
create table queue (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id),
  status text default 'waiting', -- waiting | matched | done
  room_url text,
  matched_with uuid references profiles(id),
  joined_at timestamptz default now()
);
```

---

## Getting started

```bash
# Clone
git clone https://github.com/yourhandle/xenia
cd xenia

# Install
flutter pub get

# Environment
cp .env.example .env
# Fill in: SUPABASE_URL, SUPABASE_ANON_KEY, DAILY_API_KEY

# Run
flutter run
```

---

## The one non-negotiable before launch

A report button and a manual review queue. No AI moderation yet — just two people (us) reviewing flagged sessions. Without this we should not put strangers in video calls together. This is not a Phase 2 item. It ships with v1.

---

## Built by

Greyway Co + Miles — Zimbabwe 🇿🇼

---

## Status

`🟡 In development — MVP`
