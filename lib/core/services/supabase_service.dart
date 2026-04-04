// ============================================================
// supabase_service.dart
// ------------------------------------------------------------
// Core Service: Singleton wrapper for Supabase.
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  /// Initialize Supabase using environment variables.
  static Future<void> init() async {
    final String url = dotenv.get('SUPABASE_URL', fallback: '');
    final String anonKey = dotenv.get('SUPABASE_ANON_KEY', fallback: '');

    if (url.isEmpty || anonKey.isEmpty) {
      throw Exception('SUPABASE_URL or SUPABASE_ANON_KEY not found in .env');
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true, // Enabled for development
    );
  }

  /// Reference to the Supabase Client.
  SupabaseClient get client => Supabase.instance.client;

  /// Shortcut to Auth.
  GoTrueClient get auth => client.auth;

  /// Shortcut to Postgrest (database queries).
  PostgrestClient get db => client.from(''); // Default empty reference

  /// Shortcut to Realtime logic.
  RealtimeClient get realtime => client.realtime;
}
