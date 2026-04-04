// ============================================================
// legal_page.dart
// ------------------------------------------------------------
// Page: 02. The Contract - The Sacred Rule.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'The Sacred\nRule.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: XColors.primaryPurple,
                      height: 1.1,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'This space is wild. It is random. But above all, it is respectful.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🚩', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Zero Tolerance.\nHarassment or explicit behavior results in an immediate, permanent ban.',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.redAccent,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(XRoutes.auth),
                  child: const Text('I ACCEPT'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
