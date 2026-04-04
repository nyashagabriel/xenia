// ============================================================
// x_constants.dart
// ------------------------------------------------------------
// Core configuration and single source of truth for Xenia constants.
// ============================================================

/// Navigation Routes (Full 11-screen high-fidelity flow)
class XRoutes {
  XRoutes._();

  static const String splash = '/';
  static const String legal = '/legal';        // The Contract
  static const String auth = '/auth';          // The Identity Landing
  static const String onboarding = '/onboarding'; // The vibe/permissions
  
  static const String home = '/home';          // The Hero / Catalyst
  static const String profile = '/profile';    // Reputation & Standing
  static const String history = '/history';    // Connection Log
  static const String premium = '/premium';    // Paywall
  
  static const String queue = '/queue';        // Waiting state
  static const String call = '/call';          // Live Connection
}


/// Supabase Database Table & RPC Names (Strictly synced with schema)
class XTables {
  XTables._();

  static const String users = 'users';
  static const String queue = 'queue';
  static const String reports = 'reports';
  static const String matches = 'matches';


  // RPCs
  static const String rpcClaimMatch = 'claim_match';
}

/// App Constraints & Business Logic Limits
class XLimits {
  XLimits._();

  static const int dailyFreeMatches = 20;
  static const double minReputationToEnter = 50.0;
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration queueMatchTimeout = Duration(seconds: 30);
}

/// Local Storage Keys (Shared Preferences)
class XKeys {
  XKeys._();

  static const String hasAcceptedRules = 'x_accepted_rules';
  static const String hasCompletedOnboarding = 'x_onboarding_done';
  static const String userDisplayName = 'x_display_name';
  static const String userAgeConfirmed = 'x_age_confirmed';
  static const String dailyMatchCount = 'x_match_count';
  static const String lastQuotaReset = 'x_last_reset';
}
