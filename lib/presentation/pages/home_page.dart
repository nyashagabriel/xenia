// ============================================================
// home_page.dart
// ------------------------------------------------------------
// Page: 06. The Catalyst - Home Hub.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../logic/auth_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';
import '../widgets/x_pulse_button.dart';
import '../widgets/x_glass_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Auth provider is watched but profile data used inline below
    context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'XENIA',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(XRoutes.profile),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: XColors.surfaceBorder,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Center(child: Text('👤')),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // Mirror (Pre-flight check)
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: XColors.surfaceDark,
                    borderRadius: BorderRadius.circular(40),
                    image: const DecorationImage(
                      image: NetworkImage('https://placeholder.com/600x800'), // Replace with live camera preview
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 24,
                        right: 24,
                        child: XGlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          borderRadius: 100,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              const Text('MIRROR ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // The Catalyst (Match Trigger)
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    XPulseButton(
                      onPressed: () => context.go(XRoutes.queue),
                      child: const Text(
                        'MATCH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'SpaceGrotesk',
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '1,402 FRIENDS ONLINE',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
