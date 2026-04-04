import 'package:flutter/material.dart';
import 'package:xenia/core/router_config.dart';
import 'package:xenia/core/strings.dart';
import 'package:xenia/core/theme.dart';
import 'dart:async';


void main() {
  runApp(const XeniaApp());
}

class XeniaApp extends StatelessWidget {
  const XeniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xenia',
      debugShowCheckedModeBanner: false,
      theme: XeniaTheme.darkTheme, // Defaulting to the electric Gen Z energy
      home: const XeniaFlowNavigator(),
    );
  }
}

/// A simple navigator to cycle through the "Placebo" screens
class XeniaFlowNavigator extends StatefulWidget {
  const XeniaFlowNavigator({super.key});

  @override
  State<XeniaFlowNavigator> createState() => _XeniaFlowNavigatorState();
}

class _XeniaFlowNavigatorState extends State<XeniaFlowNavigator> {
  String _currentScreen = XRoutes.splash;

  void _navigate(String route) {
    setState(() {
      _currentScreen = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case XRoutes.splash:
        return XeniaSplashScreen(onComplete: () => _navigate(XRoutes.authGate));
      case XRoutes.authGate:
        return XeniaAuthGate(onContinue: () => _navigate(XRoutes.legal));
      case XRoutes.legal:
        return XeniaLegalScreen(onAccept: () => _navigate(XRoutes.home));
      case XRoutes.home:
        return XeniaHomeHub(onMatch: () => _navigate(XRoutes.match));
      case XRoutes.match:
        return XeniaLiveMatch(onExit: () => _navigate(XRoutes.home));
      default:
        return const Scaffold(body: Center(child: Text('Error: Route not found')));
    }
  }
}

// --- SCREEN 01: SPLASH ---
class XeniaSplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const XeniaSplashScreen({super.key, required this.onComplete});

  @override
  State<XeniaSplashScreen> createState() => _XeniaSplashScreenState();
}

class _XeniaSplashScreenState extends State<XeniaSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XeniaColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _XeniaLogo(isLarge: true),
            const SizedBox(height: 48),
            const Text('XENIA', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk', color: Colors.white, letterSpacing: -2)),
            const SizedBox(height: 12),
            Text(XeniaStrings.slogan.toUpperCase(), style: const TextStyle(color: XeniaColors.purpleDark, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 02: AUTH GATE ---
class XeniaAuthGate extends StatelessWidget {
  final VoidCallback onContinue;
  const XeniaAuthGate({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _XeniaLogo(isLarge: false),
            const SizedBox(height: 48),
            const Text('Join the\ncommunity.', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk', color: Colors.white, height: 1.1)),
            const SizedBox(height: 16),
            const Text('Connect with the world, one conversation at a time.', style: TextStyle(color: XeniaColors.textMutedDark, fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60)),
              child: const Text('CONTINUE WITH APPLE'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onContinue,
              child: const Center(child: Text('CONTINUE WITH GOOGLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 03: LEGAL (THE SACRED RULE) ---
class XeniaLegalScreen extends StatelessWidget {
  final VoidCallback onAccept;
  const XeniaLegalScreen({super.key, required this.onAccept});

  @override
  Widget build(BuildContext method) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The Sacred\nRule.', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk', color: Colors.white, height: 1.1)),
              const SizedBox(height: 32),
              const Text('This space is wild. It is random. But above all, it is respectful.', style: TextStyle(color: XeniaColors.textMutedDark, fontSize: 18)),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.red.withAlpha(20), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.red.withAlpha(50))),
                child: const Text('Zero Tolerance.\n\nHarassment or explicit behavior results in an immediate, permanent device ban.', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, height: 1.5)),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 64), backgroundColor: Colors.white, foregroundColor: Colors.black),
                child: const Text('I ACCEPT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 06: HOME HUB ---
class XeniaHomeHub extends StatelessWidget {
  final VoidCallback onMatch;
  const XeniaHomeHub({super.key, required this.onMatch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XENIA'),
        actions: [
          IconButton(onPressed: () {}, icon: const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16))),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Mirror Placeholder
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 380,
            decoration: BoxDecoration(color: XeniaColors.surfaceDark, borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.white.withAlpha(10))),
            child: const Center(child: Text('Mirror Active', style: TextStyle(color: XeniaColors.textMutedDark, fontWeight: FontWeight.bold, fontSize: 12))),
          ),
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.95, end: 1.05),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, value, child) => Transform.scale(scale: value, child: child),
            child: GestureDetector(
              onTap: onMatch,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: XeniaColors.purpleDark,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: XeniaColors.purpleDark.withAlpha(80), blurRadius: 40, spreadRadius: 10)],
                ),
                child: const Center(child: Text('MATCH', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5))),
              ),
            ),
          ),
          const SizedBox(height: 48),
          const Text('1,402 Friends Online', style: TextStyle(color: XeniaColors.textMutedDark, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// --- SCREEN 08: LIVE MATCH (THE VOID) ---
class XeniaLiveMatch extends StatefulWidget {
  final VoidCallback onExit;
  const XeniaLiveMatch({super.key, required this.onExit});

  @override
  State<XeniaLiveMatch> createState() => _XeniaLiveMatchState();
}

class _XeniaLiveMatchState extends State<XeniaLiveMatch> {
  bool _showReport = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote Feed (Simulated)
          Center(child: Text('Connecting to a new friend...', style: TextStyle(color: Colors.white.withAlpha(100), fontWeight: FontWeight.bold))),
          
          // UI Overlays
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white.withAlpha(20), borderRadius: BorderRadius.circular(20)),
                        child: const Row(children: [Text('🇯🇵 ', style: TextStyle(fontSize: 18)), Text('New Friend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                      ),
                      Container(width: 100, height: 150, decoration: BoxDecoration(color: Colors.white.withAlpha(20), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withAlpha(50)))),
                    ],
                  ),
                  const Spacer(),
                  // Action Bar
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(10), borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.white.withAlpha(10))),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() => _showReport = true),
                          icon: const Icon(Icons.flag, color: Colors.redAccent, size: 28),
                          style: IconButton.styleFrom(backgroundColor: Colors.white.withAlpha(10), padding: const EdgeInsets.all(16)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onExit,
                            style: ElevatedButton.styleFrom(backgroundColor: XeniaColors.purpleDark, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                            child: const Text('SKIP'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // THE SHIELD (Report Modal Patch)
          if (_showReport) _XeniaReportModal(onCancel: () => setState(() => _showReport = false), onTerminate: widget.onExit),
        ],
      ),
    );
  }
}

// --- SUB-COMPONENTS & UTILS ---

class _XeniaLogo extends StatelessWidget {
  final bool isLarge;
  const _XeniaLogo({required this.isLarge});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 deg
      child: Container(
        width: isLarge ? 100 : 48,
        height: isLarge ? 100 : 48,
        decoration: BoxDecoration(color: XeniaColors.purpleDark, borderRadius: BorderRadius.circular(isLarge ? 32 : 12), boxShadow: [BoxShadow(color: XeniaColors.purpleDark.withAlpha(80), blurRadius: isLarge ? 40 : 20)]),
        child: Center(
          child: Transform.rotate(
            angle: -0.785398,
            child: Text('X', style: TextStyle(color: Colors.black, fontSize: isLarge ? 56 : 24, fontWeight: FontWeight.w900, fontFamily: 'SpaceGrotesk')),
          ),
        ),
      ),
    );
  }
}

class _XeniaReportModal extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onTerminate;
  const _XeniaReportModal({required this.onCancel, required this.onTerminate});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: Container(
          width: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 6, width: double.infinity, decoration: BoxDecoration(gradient: XeniaColors.warningGradient)),
              const SizedBox(height: 32),
              const CircleAvatar(backgroundColor: Color(0xFF1F2937), radius: 32, child: Icon(Icons.flag, color: Colors.redAccent, size: 32)),
              const SizedBox(height: 24),
              const Text('Report User?', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'SpaceGrotesk')),
              const Padding(padding: EdgeInsets.all(24.0), child: Text('This instantly terminates the connection and flags the user\'s device for review.', textAlign: TextAlign.center, style: TextStyle(color: XeniaColors.textMutedDark, fontSize: 12))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: onTerminate,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE11D48), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('TERMINATE'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: onCancel, child: const Text('CANCEL', style: TextStyle(color: XeniaColors.textMutedDark, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5))),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}