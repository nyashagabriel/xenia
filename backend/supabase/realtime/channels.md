# Xenia — Real-time Channel Strategy

## Overview

Xenia uses **Supabase Realtime** (Postgres Change Data Capture) as its
real-time backbone. There is **no custom WebSocket server** — all signaling
and state changes flow through the `match_queue` table.

---

## The Single Channel Pattern

The Flutter app subscribes to **one channel per session**:

```dart
supabase
  .channel('user-queue:$userId')
  .onPostgresChanges(
    event:  PostgresChangeEvent.all,
    schema: 'public',
    table:  'match_queue',
    filter: 'user_id=eq.$userId OR matched_with=eq.$userId',
    callback: (payload) => _handleQueueChange(payload),
  )
  .subscribe();
```

This fires on **any change** to either the user's own row OR their
partner's row — enabling bidirectional reactions from a single subscription.

---

## Row Ownership

| Row belongs to | Contains |
|----------------|----------|
| User A (initiator) | `webrtc_offer` (SDP offer), ICE candidates from A |
| User B (acceptor)  | `webrtc_answer` (SDP answer), ICE candidates from B |

The Flutter app detects its role by checking `webrtc_offer` — if the
partner's row has an offer and the user's own row does not, they are the
**acceptor** and must write back an answer.

---

## State Transition Flow

```
[Home Hub]
    │
    ▼  (tap MATCH → call join-queue fn)
    │
    ├── CASE: No partner available
    │      → insert own row: status = 'searching'
    │      → UI shows "waiting..."
    │      → Realtime fires when status → 'matched'
    │
    └── CASE: Partner found
           → own row inserted as: status = 'matched'
           → partner row updated to: status = 'matched'
           → Both clients receive Realtime update
           → WebRTC offer/answer exchange begins (see signaling.md)
           → When ICE complete: both rows → status = 'connected'
           → UI shows live video

[Live Match]
    │
    ├── SKIP → call skip-match fn
    │      → both rows deleted from match_queue
    │      → Both clients receive DELETE event → navigate to Home Hub
    │
    └── REPORT → call report-user fn
           → same as skip, but also files user_reports record
```

---

## Presence (Future)

The "X Friends Online" count on the Home Hub will use **Supabase Realtime Presence**:

```dart
final channel = supabase.channel('global-presence');
channel.subscribe((status, _) async {
  if (status == RealtimeSubscribeStatus.subscribed) {
    await channel.track({ 'user_id': userId, 'status': 'online' });
  }
});
```

The online count is then derived from `channel.presenceState().length`.
This is client-side estimated — no DB write required.
