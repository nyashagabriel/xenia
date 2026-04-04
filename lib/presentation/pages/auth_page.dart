// ============================================================
// auth_page.dart
// ------------------------------------------------------------
// Page: 03. The Identity - Join the Community.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Column(
        children: [
          // Top Brand Section (Left side of web wireframe)
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color: XColors.darkBackground,
              child: Stack(
                children: [
                  // Glow Effect
                  Positioned(
                    top: -100,
                    left: -100,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: XColors.primaryPurple.withOpacity(0.15),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Embrace The\nUnexpected.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SpaceGrotesk',
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Instant, high-quality video connections with new friends globally. No algorithms. Just real people.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Section (Right side of web wireframe)
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Join the community.',
                    style: TextStyle(
                      color: XColors.darkBackground,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Continue below to start matching instantly.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const Spacer(),
                  
                  if (auth.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(auth.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: auth.status == AuthStatus.initial 
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            await auth.signInAnonymously();
                            if (context.mounted) context.go(XRoutes.onboarding);
                          },
                          child: const Text('QUICK START'),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {}, // Future: Social Login
                      child: Text(
                        'USE GOOGLE OR APPLE',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.black26,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
