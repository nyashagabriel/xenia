// ============================================================
// storage_service.dart
// ------------------------------------------------------------
// Core Service: Singleton wrapper for SharedPreferences.
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';
import '../constants/x_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  /// Initialize local storage.
  static Future<void> init() async {
    _instance._prefs = await SharedPreferences.getInstance();
  }

  /// Check if the user has accepted the hospitality code.
  bool get hasAcceptedRules => _prefs.getBool(XKeys.hasAcceptedRules) ?? false;

  /// Set rule acceptance status.
  Future<void> setAcceptedRules(bool val) => _prefs.setBool(XKeys.hasAcceptedRules, val);

  /// Check if onboarding is complete.
  bool get hasCompletedOnboarding => _prefs.getBool(XKeys.hasCompletedOnboarding) ?? false;

  /// Set onboarding status.
  Future<void> setCompletedOnboarding(bool val) => _prefs.setBool(XKeys.hasCompletedOnboarding, val);

  /// Get the local display name cache.
  String? get userDisplayName => _prefs.getString(XKeys.userDisplayName);

  /// Cache the display name locally for faster startup.
  Future<void> cacheDisplayName(String name) => _prefs.setString(XKeys.userDisplayName, name);

  /// Clean all local state (Logout / Reset).
  Future<void> clear() => _prefs.clear();
}
