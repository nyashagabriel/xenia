// ============================================================
// splash_page.dart
// ------------------------------------------------------------
// Page: 01. The Threshold - App Entry & Auth Check.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    // 1. Minimum delay for branding pulse
    await Future.delayed(XLimits.splashDelay);

    if (!mounted) return;

    // 2. Check Auth Status from Provider
    final auth = context.read<AuthProvider>();
    
    if (auth.status == AuthStatus.authenticated) {
      context.go(XRoutes.home);
    } else {
      context.go(XRoutes.legal); // Start with Hospitality Code
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             // Pulsing Logo (X)
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: XColors.primaryPurple,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: XColors.primaryPurple.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'X',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'XENIA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontFamily: 'SpaceGrotesk',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'HOSPITALITY BETWEEN NEW FRIENDS',
              style: TextStyle(
                color: XColors.primaryPurpleLight.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
