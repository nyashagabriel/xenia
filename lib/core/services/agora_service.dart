// ============================================================
// agora_service.dart
// ------------------------------------------------------------
// Core Service: Wrapper for Agora RTC Engine and Permissions.
// ============================================================

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  RtcEngine? _engine;
  final String _appId = dotenv.get('AGORA_APP_ID', fallback: '');

  /// Initialize Agora Engine and Permission Status.
  Future<void> init() async {
    if (_appId.isEmpty) {
      throw Exception('AGORA_APP_ID not found in .env');
    }

    // 1. Check Permissions
    await [Permission.camera, Permission.microphone].request();

    // 2. Setup Engine
    _engine = await createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: _appId));
    
    // 3. Configure Video Settings
    await _engine!.enableVideo();
    await _engine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 480),
        frameRate: 15,
        bitrate: 400,
      ),
    );
  }

  /// Exposed Engine instance.
  RtcEngine get engine {
    if (_engine == null) throw Exception('AgoraService not initialized');
    return _engine!;
  }

  /// Clean up media resources.
  Future<void> dispose() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
    }
  }
}
