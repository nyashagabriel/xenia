// ============================================================
// router_config.dart
// ------------------------------------------------------------
// Core Navigation: GoRouter configuration for the full 11-screen flow.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants/x_constants.dart';

// Import Presentation Pages
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/legal_page.dart';
import '../presentation/pages/auth_page.dart';
import '../presentation/pages/onboarding_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/queue_page.dart';
import '../presentation/pages/call_page.dart';
import '../presentation/pages/profile_page.dart';
import '../presentation/pages/history_page.dart';
import '../presentation/pages/premium_page.dart';

final GoRouter xRouter = GoRouter(
  initialLocation: XRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // 01. Splash Screen
    GoRoute(
      path: XRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    
    // 02. The Contract (Legal Acceptance)
    GoRoute(
      path: XRoutes.legal,
      builder: (context, state) => const LegalPage(),
    ),

    // 03. The Identity Landing (Auth Options)
    GoRoute(
      path: XRoutes.auth,
      builder: (context, state) => const AuthPage(),
    ),
    
    // 04 & 05. The Vibe/Permissions (Onboarding Flow)
    GoRoute(
      path: XRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    
    // 06. The Catalyst (Hero / Home Hub)
    GoRoute(
      path: XRoutes.home,
      builder: (context, state) => const HomePage(),
    ),

    // 07. Profile View
    GoRoute(
      path: XRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),

    // History View (Connection Log)
    GoRoute(
      path: XRoutes.history,
      builder: (context, state) => const HistoryPage(),
    ),

    // 09. Processing / Queue
    GoRoute(
      path: XRoutes.queue,
      builder: (context, state) => const QueuePage(),
    ),

    // 08. The Connection (Live Video)
    GoRoute(
      path: XRoutes.call,
      builder: (context, state) => const CallPage(),
    ),

    // 11. Paywall
    GoRoute(
      path: XRoutes.premium,
      builder: (context, state) => const PremiumPage(),
    ),
  ],
);
