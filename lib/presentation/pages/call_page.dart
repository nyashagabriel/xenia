// ============================================================
// call_page.dart
// ------------------------------------------------------------
// Page: 08. The Connection - Live Video Call with Agora.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../logic/auth_provider.dart';
import '../../logic/match_provider.dart';
import '../../logic/call_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';
import '../widgets/x_glass_card.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    super.initState();
    _initCall();
  }

  void _initCall() {
    final match = context.read<MatchProvider>();
    final auth = context.read<AuthProvider>();
    
    if (match.channelName != null && auth.currentUser != null) {
      context.read<CallProvider>().startCall(match.channelName!, auth.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final call = context.watch<CallProvider>();
    final match = context.watch<MatchProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Remote Video (Full Screen)
          Container(
            color: XColors.surfaceDark,
            child: call.status == CallStatus.connected
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: AgoraService().engine,
                      canvas: RemoteVideoCanvas(uid: _convertUid(match.partnerId!)),
                      connection: RtcConnection(channelId: match.channelName!),
                    ),
                  )
                : const Center(child: CircularProgressIndicator(color: Colors.white24)),
          ),

          // 2. Local Video (Picture-in-picture)
          Positioned(
            top: 64,
            right: 24,
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black45)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: context.read<CallProvider>()._agora.engine,
                    canvas: const VideoCanvas(uid: 0), // 0 is local uid
                  ),
                ),
              ),
            ),
          ),

          // 3. User Info Overlay
          Positioned(
            top: 64,
            left: 24,
            child: XGlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.partnerName ?? 'New Friend',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk'),
                  ),
                  const Text('CONNECTED', style: TextStyle(fontSize: 8, letterSpacing: 1, color: Colors.green)),
                ],
              ),
            ),
          ),

          // 4. Interaction Controls
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularButton(
                  onPressed: () => call.toggleMic(),
                  icon: call.isMicMuted ? Icons.mic_off : Icons.mic,
                  color: call.isMicMuted ? Colors.red : Colors.white24,
                ),
                
                // SKIP Button (The Catalyst)
                GestureDetector(
                  onTap: () async {
                    await call.endCall();
                    if (mounted) context.go(XRoutes.queue); // Instant next match
                  },
                  child: Container(
                    height: 80,
                    width: 140,
                    decoration: BoxDecoration(
                      color: XColors.primaryPurple,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [BoxShadow(color: XColors.primaryPurple.withOpacity(0.5), blurRadius: 20)],
                    ),
                    child: const Center(
                      child: Text(
                        'SKIP',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2),
                      ),
                    ),
                  ),
                ),

                _buildCircularButton(
                   onPressed: () => _showReportDialog(context),
                   icon: Icons.shield_outlined,
                   color: Colors.white24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({required VoidCallback onPressed, required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: onPressed,
      child: XGlassCard(
        borderRadius: 100,
        color: color,
        padding: const EdgeInsets.all(16),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    // Show report modal... Implement Post-MVP or as needed.
  }

  int _convertUid(String uuid) {
     return int.parse(uuid.substring(0, 8), radix: 16);
  }
}
破折号: /* Private engine fix in next step */
