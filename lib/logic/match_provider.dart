// ============================================================
// match_provider.dart
// ------------------------------------------------------------
// Logic: Core Match Engine: Queue -> Detect -> Claim -> Ready.
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_service.dart';
import '../core/constants/x_constants.dart';

enum MatchStatus { idle, searching, claiming, matched, timeout, error }

class MatchProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();

  MatchStatus _status = MatchStatus.idle;
  MatchStatus get status => _status;

  String? _channelName;
  String? get channelName => _channelName;

  String? _partnerId;
  String? get partnerId => _partnerId;

  String? _partnerName;
  String? get partnerName => _partnerName;

  String? _error;
  String? get error => _error;

  RealtimeChannel? _queueSub;
  Timer? _timeoutTimer;

  /// 1. Enter the Queue
  Future<void> joinQueue(String currentUserId, {String language = 'English'}) async {
    _status = MatchStatus.searching;
    _channelName = null;
    _partnerId = null;
    _partnerName = null;
    _error = null;
    notifyListeners();

    try {
      // a. Insert 'waiting' row
      await _supabase.client.from(XTables.queue).upsert({
        'user_id': currentUserId,
        'status': 'waiting',
        'language_pref': language,
        'entered_at': DateTime.now().toIso8601String(),
      });

      // b. Listen for someone joining
      _startQueueListener(currentUserId);
      
      // c. Set timeout
      _timeoutTimer = Timer(XLimits.queueMatchTimeout, () => _handleTimeout(currentUserId));

    } catch (e) {
      _error = e.toString();
      _status = MatchStatus.error;
      notifyListeners();
    }
  }

  /// 2. Realtime Listener for other 'waiting' users
  void _startQueueListener(String currentUserId) {
    _queueSub = _supabase.client
        .channel('public:${XTables.queue}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: XTables.queue,
          callback: (payload) {
            // Check if we matched with someone else
            final newVal = payload.newRecord;
            if (newVal['user_id'] == currentUserId && newVal['status'] == 'matched') {
              _onMatchConfirmed(newVal);
              return;
            }

            // Detect someone else waiting and try to claim them
            if (newVal['user_id'] != currentUserId && newVal['status'] == 'waiting') {
              _tryClaimMatch(newVal['user_id']);
            }
          },
        )
        .subscribe();
  }

  /// 3. Atomic RPC Claim (Atomic Race Condition Protection)
  Future<void> _tryClaimMatch(String targetUserId) async {
    if (_status != MatchStatus.searching) return;

    _status = MatchStatus.claiming;
    notifyListeners();

    try {
      final response = await _supabase.client.rpc(
        XTables.rpcClaimMatch,
        params: {'target_user_id': targetUserId},
      );

      if (response != null && response['status'] == 'matched') {
        _onMatchConfirmed(response);
      } else {
        // Match failed (claimed by someone else), go back to searching
        if (_status == MatchStatus.claiming) {
          _status = MatchStatus.searching;
          notifyListeners();
        }
      }
    } catch (e) {
      // RPC error (deadlock or concurrent claim), safe to retry searching
      _status = MatchStatus.searching;
      notifyListeners();
    }
  }

  /// 4. Finalize Connection
  void _onMatchConfirmed(Map<String, dynamic> data) {
    _timeoutTimer?.cancel();
    _status = MatchStatus.matched;
    _channelName = data['channel_name'] ?? data['agora_channel'];
    _partnerId = data['partner_id'] ?? data['matched_with'];
    _partnerName = data['partner_name'] ?? 'New Friend';
    
    _queueSub?.unsubscribe();
    notifyListeners();
  }

  /// Cleanup
  void leaveQueue(String currentUserId) async {
    _timeoutTimer?.cancel();
    _queueSub?.unsubscribe();
    _status = MatchStatus.idle;
    
    await _supabase.client
        .from(XTables.queue)
        .delete()
        .eq('user_id', currentUserId);
        
    notifyListeners();
  }

  void _handleTimeout(String currentUserId) {
    if (_status == MatchStatus.searching) {
      _status = MatchStatus.timeout;
      leaveQueue(currentUserId);
    }
  }
}
