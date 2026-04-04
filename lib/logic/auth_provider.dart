// ============================================================
// auth_provider.dart
// ------------------------------------------------------------
// Logic: Manages Supabase Authentication and User Profile.
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_service.dart';
import '../core/services/storage_service.dart';
import '../core/constants/x_constants.dart';

enum AuthStatus { initial, unauthenticated, authenticated, banned, error }

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  final StorageService _storage = StorageService();

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  User? _currentUser;
  User? get currentUser => _currentUser;

  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? get userProfile => _userProfile;

  String? _error;
  String? get error => _error;

  /// Initialize and check for existing session
  Future<void> init() async {
    _currentUser = _supabase.auth.currentUser;

    if (_currentUser != null) {
      await _fetchProfile();
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Perform Anonymous Sign-in (MVP Standard)
  Future<void> signInAnonymously() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      _currentUser = response.user;
      
      if (_currentUser != null) {
        await _fetchProfile();
      }
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  /// Fetch profile data from 'users' table
  Future<void> _fetchProfile() async {
    if (_currentUser == null) return;

    try {
      final data = await _supabase.client
          .from(XTables.users)
          .select()
          .eq('id', _currentUser!.id)
          .single();

      _userProfile = data;

      if (data['is_banned'] == true) {
        _status = AuthStatus.banned;
      } else {
        _status = AuthStatus.authenticated;
        // Sync to local cache for fast UI building
        _storage.cacheDisplayName(data['display_name'] ?? 'Anonymous');
      }
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  /// Update display name and complete onboarding
  Future<bool> completeOnboarding(String name, bool ageConfirmed) async {
    if (_currentUser == null) return false;

    try {
      await _supabase.client.from(XTables.users).update({
        'display_name': name,
        'age_confirmed': ageConfirmed,
      }).eq('id', _currentUser!.id);

      await _fetchProfile();
      await _storage.setCompletedOnboarding(true);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _storage.clear();
    _currentUser = null;
    _userProfile = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
