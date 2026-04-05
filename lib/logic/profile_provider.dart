// ============================================================
// profile_provider.dart
// ----------------------------
// Logic: User Stats & Reputation standing.
// ============================================================

import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../core/constants/x_constants.dart';

class ProfileProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? get profile => _profile;

  int _totalMatchDuration = 0;
  int get totalMatchDuration => _totalMatchDuration;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetch full profile and aggregated stats
  Future<void> fetchFullProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch Basic Profile
      final profileData = await _supabase.client
          .from(XTables.users)
          .select()
          .eq('id', userId)
          .single();

      _profile = profileData;

      // 2. Aggregate Match Stats (Sum of duration)
      final historyData = await _supabase.client
          .from(XTables.matches)
          .select('duration_seconds')
          .or('user_1_id.eq.$userId,user_2_id.eq.$userId');

      _totalMatchDuration = 0;
      for (var row in historyData) {
        _totalMatchDuration += (row['duration_seconds'] as int? ?? 0);
      }

    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update reputation score (triggered by system or partner feedback)
  Future<void> updateReputation(String userId, double adjustment) async {
    if (_profile == null) return;
    
    final double current = (_profile!['reputation_score'] as num? ?? 100).toDouble();
    final double updated = (current + adjustment).clamp(0.0, 100.0);

    try {
      await _supabase.client
          .from(XTables.users)
          .update({'reputation_score': updated})
          .eq('id', userId);
      
      _profile!['reputation_score'] = updated;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating reputation: $e');
    }
  }
}
