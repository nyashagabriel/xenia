// ============================================================
// onboarding_page.dart
// ------------------------------------------------------------
// Page: 04-05. The Vibe & Permissions - Profile setup.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../logic/auth_provider.dart';
import '../../core/constants/x_constants.dart';
import '../../core/theme/x_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  bool _ageConfirmed = false;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _finalize();
    }
  }

  Future<void> _finalize() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.completeOnboarding(_nameController.text, _ageConfirmed);
    if (success && mounted) {
      context.go(XRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.primaryPurple,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentPage >= index ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildNameStep(),
                  _buildAgeStep(),
                  _buildPermissionStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return _BaseStep(
      emoji: '👽',
      title: 'What should we\ncall you?',
      onAction: _nextPage,
      child: TextField(
        controller: _nameController,
        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          hintText: 'Display Name',
          hintStyle: TextStyle(color: Colors.white38),
          filled: false,
        ),
      ),
    );
  }

  Widget _buildAgeStep() {
    return _BaseStep(
      emoji: '🔞',
      title: 'Wait, are you\n18+ only?',
      onAction: _ageConfirmed ? _nextPage : null,
      child: SwitchListTile(
        title: const Text('I confirm I am over 18', style: TextStyle(color: Colors.white)),
        value: _ageConfirmed,
        onChanged: (v) => setState(() => _ageConfirmed = v),
        activeThumbColor: Colors.white,
      ),
    );
  }

  Widget _buildPermissionStep() {
    return _BaseStep(
      emoji: '🎥',
      title: 'We need your\nCamera & Mic.',
      actionLabel: 'GRANT ACCESS',
      onAction: () async {
        await [Permission.camera, Permission.microphone].request();
        _nextPage();
      },
      child: const Text(
        'Xenia is live video. You need camera access to jump in and meet people.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}

class _BaseStep extends StatelessWidget {
  final String emoji;
  final String title;
  final Widget child;
  final VoidCallback? onAction;
  final String actionLabel;

  const _BaseStep({
    required this.emoji,
    required this.title,
    required this.child,
    this.onAction,
    this.actionLabel = 'NEXT',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (emoji.isEmpty)
             Image.asset('assets/onboarding_hero.webp', height: 200)
          else
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
            ),

          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontFamily: 'SpaceGrotesk',
              height: 1.1,
            ),
          ),
          const SizedBox(height: 48),
          child,
          const SizedBox(height: 64),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: XColors.primaryPurple,
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}
