# Xenia — Agora RTC Integration

Xenia uses **Agora RTC** for high-performance video chat. This document 
outlines the integration between Supabase (matching) and Agora (media).

---

## Architecture Flow

1. **Match Claimed**: The Supabase `claim_match` RPC pairs two users and 
generates a unique `agora_channel` (a UUID).
2. **Token Fetch**: Each UI client (A and B) calls the `get-agora-token` 
Supabase Edge Function.
3. **RTC Join**: Both clients join the channel using the fetched token.
    - **Channel Name**: The `agora_channel` from the `queue` row.
    - **UID**: Agora requires an integer UID. We derive this from the user's 
    Supabase UUID (last 9 digits) to ensure consistency.

---

## Integer UID Logic (Flutter)

Since Agora requires a `uint32`, we should map the Supabase UUID:

```dart
// lib/core/agora_utils.dart
int getAgoraUid(String supabaseUuid) {
  // Use the integer representation of the first 8 characters
  return int.parse(supabaseUuid.substring(0, 8), radix: 16);
}
```

---

## Token Generation (Server-Side)

Tokens are generated via the `get-agora-token` edge function to keep 
the **App Certificate** secure.

**Required Secrets (Supabase):**
- `AGORA_APP_ID`: From Agora Dashboard.
- `AGORA_APP_CERTIFICATE`: From Agora Dashboard (Security Settings).

---

## Flutter Implementation

```yaml
# pubspec.yaml
dependencies:
  agora_rtc_engine: ^6.3.2
```

**Initialization:**
```dart
final engine = createAgoraRtcEngine();
await engine.initialize(const RtcEngineContext(appId: AGORA_APP_ID));
await engine.enableVideo();
await engine.startPreview();

// Join after fetching token from Supabase Edge Function
await engine.joinChannel(
  token: response.token,
  channelId: queueRow.agoraChannel,
  uid: getAgoraUid(currentUserId),
  options: const ChannelMediaOptions(),
);
```
