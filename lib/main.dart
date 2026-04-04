// ============================================================
// main.dart
// ------------------------------------------------------------
// Xenia: A stress-release video chat for Gen Z.
// Application entry point with async service initialization.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/services/supabase_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/agora_service.dart';
import 'core/theme/x_theme.dart';
import 'core/router_config.dart';

import 'logic/auth_provider.dart';
import 'logic/match_provider.dart';
import 'logic/call_provider.dart';
import 'logic/profile_provider.dart';
import 'logic/history_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load Environment Variables (.env)
  await dotenv.load(fileName: '.env');

  // 2. Initialize Core Services
  try {
    await SupabaseService.init();
    await StorageService.init();
  } catch (e) {
    debugPrint('❌ Core Service Initialization Failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        // Infrastructure Singletons
        Provider.value(value: SupabaseService()),
        Provider.value(value: StorageService()),
        Provider.value(value: AgoraService()),
        
        // Logic Providers (State Management)
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const XeniaApp(),
    ),
  );
}


class XeniaApp extends StatelessWidget {
  const XeniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Xenia',
      debugShowCheckedModeBanner: false,
      
      // Design System
      theme: XTheme.light(),
      darkTheme: XTheme.dark(),
      themeMode: ThemeMode.system,
      
      // Navigation
      routerConfig: xRouter,
    );
  }
}