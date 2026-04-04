# Xenia — Match Queue State Machine

## States

These match `XQueueStatus` in `lib/core/router_config.dart`.

```
         ┌──────────────────────────────────────────────┐
         │               match_queue row                 │
         │                                              │
         │    idle ──► searching ──► matched ──► connected
         │                │              │            │
         │                │              │            │
         │                └──► (deleted) └──► (deleted on skip/report)
         └──────────────────────────────────────────────┘
```

| State | Meaning | Next states |
|-------|---------|-------------|
| `idle` | Not in the queue (no row exists) | `searching` |
| `searching` | Waiting for a partner | `matched`, `idle` (leave) |
| `matched` | Partner found; WebRTC SDP exchange in progress | `connected`, `idle` (timeout) |
| `connected` | ICE complete; P2P video is live | `idle` (skip/report/drop) |
| `disconnected` | Set briefly on drop before row deletion | *(deleted)* |

---

## Transition Triggers

| Transition | Triggered by |
|------------|-------------|
| `idle → searching` | `join-queue` edge function (no partner found) |
| `searching → matched` | `join-queue` edge function (partner found) |
| `matched → connected` | Flutter client (ICE negotiation complete) |
| `connected → idle` | `skip-match` or `report-user` edge function (row deleted) |
| `matched → idle` | Match timeout (30s) — TODO: implement via pg_cron or edge function |
| Any → `idle` | Network drop — Flutter detects Realtime disconnect |

---

## Match Timeout (TODO)

If WebRTC negotiation fails to produce a `connected` state within
`XLimits.matchTimeout` (30 seconds), both users should be returned to idle.

**Implementation options:**
1. **pg_cron** — Scheduled job every minute deletes stale `matched` rows
2. **Client-side timer** — Flutter starts a 30s timer when status hits `matched`;
   calls `skip-match` if it expires before `connected` is reached (simpler)

**Recommendation:** Start with Option 2 (client-side timer) to keep MVP simple.
