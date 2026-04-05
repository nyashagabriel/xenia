// ============================================================
// history_provider.dart
// ------------------------------------------------------------
// Logic: Connection Log: Fetching past matches.
// ============================================================

import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import '../core/constants/x_constants.dart';

class HistoryProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  List<Map<String, dynamic>> _matches = [];
  List<Map<String, dynamic>> get matches => _matches;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Fetch history for the current user
  Future<void> fetchHistory(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch matches where user is either id_1 or id_2
      final response = await _supabase.client
          .from(XTables.matches)
          .select('*, user_1:users(display_name, reputation_score), user_2:users(display_name, reputation_score)')
          .or('user_1_id.eq.$userId,user_2_id.eq.$userId')
          .order('started_at', ascending: false);

      _matches = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Helper to get the 'Partner' name from a match record
  String getPartnerName(Map<String, dynamic> match, String currentUserId) {
     if (match['user_1_id'] == currentUserId) {
        return match['user_2']['display_name'] ?? 'Friend';
     } else {
        return match['user_1']['display_name'] ?? 'Friend';
     }
  }
}
