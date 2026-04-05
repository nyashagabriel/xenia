// ============================================================
// call_provider.dart
// ------------------------------------------------------------
// Logic: Agora RTC Session: Token Fetch -> Join -> State.
// ============================================================

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../core/services/supabase_service.dart';
import '../core/services/agora_service.dart';

enum CallStatus { idle, fetchingToken, joining, connected, error }

class CallProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  final AgoraService _agora = AgoraService();

  CallStatus _status = CallStatus.idle;
  CallStatus get status => _status;

  bool _isMicMuted = false;
  bool get isMicMuted => _isMicMuted;

  bool _isCamOff = false;
  bool get isCamOff => _isCamOff;

  String? _error;
  String? get error => _error;

  /// Expose Agora engine for video views.
  RtcEngine get engine => _agora.engine;

  /// Start the Video Session
  Future<void> startCall(String channelName, String userId) async {
    _status = CallStatus.fetchingToken;
    _error = null;
    notifyListeners();

    try {
      // 1. Fetch Token from Supabase Edge Function
      final token = await _fetchAgoraToken(channelName, userId);
      
      // 2. Initialize Hardware & Join
      await _agora.init();
      
      _status = CallStatus.joining;
      notifyListeners();

      await _agora.engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: _getAgoraUid(userId),
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
        ),
      );

      _status = CallStatus.connected;
      notifyListeners();

    } catch (e) {
      _status = CallStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Fetch token via Supabase Functions URL
  Future<String> _fetchAgoraToken(String channelName, String userId) async {
    final response = await _supabase.client.functions.invoke(
      'get-agora-token',
      body: {
        'channelName': channelName,
        'uid': _getAgoraUid(userId),
      },
    );

    if (response.status == 200) {
      final Map<String, dynamic> data = response.data;
      return data['token'];
    } else {
      throw Exception('Failed to fetch Agora token: ${response.status}');
    }
  }

  /// Maps Supabase UUID to Agora uint32 UID
  int _getAgoraUid(String uuid) {
     // Use the first 8 characters of the UUID as a hex integer
     return int.parse(uuid.substring(0, 8), radix: 16);
  }

  /// Toggle Audio State
  Future<void> toggleMic() async {
    _isMicMuted = !_isMicMuted;
    await _agora.engine.muteLocalAudioStream(_isMicMuted);
    notifyListeners();
  }

  /// Toggle Video State
  Future<void> toggleCamera() async {
    _isCamOff = !_isCamOff;
    await _agora.engine.muteLocalVideoStream(_isCamOff);
    notifyListeners();
  }

  /// End Session
  Future<void> endCall() async {
    await _agora.dispose();
    _status = CallStatus.idle;
    notifyListeners();
  }
}
