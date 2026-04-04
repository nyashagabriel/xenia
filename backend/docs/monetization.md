# Xenia — Monetization Logic

## Tiers

| Tier | Price | Daily matches | Queue priority | Ads |
|------|-------|---------------|----------------|-----|
| Free | $0 | 20 per 12h window | Standard FIFO | Yes (future) |
| Xenia Plus | $4.99/month | Unlimited | Priority | No |

---

## Daily Quota Logic

The quota is enforced **server-side** in edge functions — the client-side
count in `XBoxes.keyDailyMatchCount` (SharedPreferences) is for display
only and is re-synced from the server on every app launch.

### Reset Window

The counter resets when **12 hours have elapsed** since the last reset,
not at fixed midnight. This means a user who maxes out at 3 PM can use
the app again at 3 AM — a gentler, timezone-agnostic approach.

### Server enforcement (inside `join-queue`)

```typescript
const hoursSinceReset = (Date.now() - new Date(profile.last_match_reset).getTime()) / 3_600_000

if (hoursSinceReset >= 12) {
  // Reset the counter
  await supabase.from('profiles').update({
    daily_match_count: 0,
    last_match_reset: new Date().toISOString()
  }).eq('id', user.id)
  profile.daily_match_count = 0
}

if (!profile.is_plus && profile.daily_match_count >= 20) {
  // Return 429 with recharge time
  return json({ error: 'quota_exceeded', recharges_at: ... }, 429)
}
```

### Flutter handling

When `join-queue` returns `429`:
- Navigate to `XRoutes.paywall`
- Pass `recharges_at` timestamp to display countdown

---

## Subscription Management

Xenia Plus is managed via **Stripe** (recommended) or **RevenueCat** for
in-app purchase on iOS/Android, and Stripe Checkout on web.

On successful payment:
1. Stripe webhook calls a `stripe-webhook` edge function (TODO)
2. Edge function sets `profiles.is_plus = true` and `plus_expires_at`

On expiry:
- A scheduled pg_cron job (or Stripe webhook for `customer.subscription.deleted`)
  sets `is_plus = false`

---

## Priority Queue (Xenia Plus feature)

When `is_plus = true`, the `join-queue` edge function uses a modified
partner-search query that orders Plus users first:

```sql
SELECT id, user_id FROM match_queue
WHERE status = 'searching'
  AND user_id != $callerId
ORDER BY 
  (SELECT is_plus FROM profiles WHERE id = user_id) DESC,  -- Plus first
  joined_at ASC
LIMIT 1;
```

This rewards paying users with faster matches without ever telling free
users they're deprioritized.
