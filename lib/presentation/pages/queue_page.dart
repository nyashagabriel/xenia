// ============================================================
// queue_page.dart
// ------------------------------------------------------------
// Page: 09. Processing - Match Queue.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../logic/auth_provider.dart';
import '../../logic/match_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';
import '../widgets/x_pulse_button.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  @override
  void initState() {
    super.initState();
    _startMatching();
  }

  void _startMatching() {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId != null) {
      context.read<MatchProvider>().joinQueue(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = context.watch<MatchProvider>();

    // Navigation logic based on match status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (match.status == MatchStatus.matched) {
        context.go(XRoutes.call);
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: XColors.darkBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            XPulseButton(
              onPressed: () {
                 final userId = context.read<AuthProvider>().currentUser?.id;
                 if (userId != null) context.read<MatchProvider>().leaveQueue(userId);
                 context.go(XRoutes.home);
              },
              color: XColors.accentWarning,
              child: const Text('CANCEL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            
            const SizedBox(height: 64),
            
            Text(
              _getStatusText(match.status),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontFamily: 'SpaceGrotesk',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Finding you a relevant connection...',
              style: TextStyle(color: Colors.white54),
            ),

            if (match.status == MatchStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text('Error: ${match.error}', style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(MatchStatus status) {
    switch (status) {
      case MatchStatus.searching: return 'SEARCHING...';
      case MatchStatus.claiming: return 'CONNECTING...';
      case MatchStatus.matched: return 'MATCH FOUND!';
      case MatchStatus.timeout: return 'NO ONE FOUND';
      case MatchStatus.error: return 'FAILED';
      default: return 'PREPARING...';
    }
  }
}
