export 'package:flutter/foundation.dart';

/// Xenia Navigation Routes - Mapped to the 11-screen Architecture
class XRoutes {
  XRoutes._();

  static const String splash = '/';
  static const String authGate = '/auth';
  static const String legal = '/legal'; // Hospitality Code
  static const String onboarding = '/onboarding';
  static const String languagePref = '/preferences/language';
  
  static const String home = '/home'; // The Catalyst
  static const String history = '/history'; // Connection Log
  static const String profile = '/profile';
  
  static const String match = '/match'; // The Community Connection
  static const String paywall = '/premium/paywall';
}

/// Local Storage Keys (Hive/SharedPrefs)
class XBoxes {
  XBoxes._();

  static const String appSettings = 'app_settings';
  static const String userCache = 'user_cache';
  static const String hospitalityAgreement = 'legal_acceptance';
  
  static const String keyAcceptedCode = 'has_accepted_hospitality_code';
  static const String keyDailyMatchCount = 'matches_today_count';
  static const String keyLastMatchReset = 'last_reset_timestamp';
  static const String keyPreferredLanguage = 'user_pref_lang';
}

/// Supabase Table Names
class XTables {
  XTables._();

  static const String profiles = 'profiles';
  static const String queue = 'match_queue';
  static const String matches = 'match_history';
  static const String reports = 'user_reports';
}

/// Real-time Queue States (The State Machine)
class XQueueStatus {
  XQueueStatus._();

  static const String idle = 'idle';
  static const String searching = 'searching';
  static const String matched = 'matched';
  static const String connected = 'connected';
  static const String disconnected = 'disconnected';
}

/// Global Logic & UX Limits
class XLimits {
  XLimits._();

  // Monetization & Quota
  static const int dailyFreeMatches = 20;
  static const Duration rechargeInterval = Duration(hours: 12);
  
  // UI Constraints
  static const int usernameMaxChars = 20;
  static const int reportReasonMaxChars = 200;
  
  // Connectivity
  static const Duration matchTimeout = Duration(seconds: 30);
  static const Duration syncDebounce = Duration(seconds: 3);
}

/// Support & Legal Metadata
class XSupport {
  XSupport._();

  static const String email = 'hospitality@xenia.app';
  static const String subject = 'Xenia Support Request';
  static const String website = 'https://xenia.co';
}

/// Data Parsing Utilities (Greyway Signature)
class XJson {
  XJson._();

  static String str(Map<String, dynamic> json, String key,
      {String fallback = ''}) {
    final v = json[key];
    if (v == null) return fallback;
    return v.toString();
  }

  static int integer(Map<String, dynamic> json, String key,
      {int fallback = 0}) {
    final v = json[key];
    if (v == null) return fallback;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? fallback;
  }

  static bool boolean(Map<String, dynamic> json, String key,
      {bool fallback = false}) {
    final v = json[key];
    if (v == null) return fallback;
    if (v is bool) return v;
    return v.toString().toLowerCase() == 'true';
  }

  static DateTime? dateTimeOrNull(Map<String, dynamic> json, String key) {
    final v = json[key];
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  static DateTime dateTime(Map<String, dynamic> json, String key) {
    final v = json[key];
    if (v == null) return DateTime.now();
    return DateTime.tryParse(v.toString()) ?? DateTime.now();
  }
}
