// ============================================================
// x_theme.dart
// ------------------------------------------------------------
// Xenia Theme Definition: Space Grotesk x Poppins.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'x_colors.dart';

class XTheme {
  XTheme._();

  /// The Dark High-Fidelity Theme (Primary for Gen Z chaos mode)
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: XColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: XColors.primaryPurple,
        brightness: Brightness.dark,
        surface: XColors.surfaceDark,
        onSurface: Colors.white,
        primary: XColors.primaryPurpleLight,
        error: XColors.accentAlert,
      ),
      
      // Typography
      textTheme: _buildTextTheme(Brightness.dark),
      
      // Components
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
      cardTheme: _buildCardTheme(Brightness.dark),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
    );
  }

  /// The Light High-Fidelity Theme (Clean & Professional)
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: XColors.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: XColors.primaryPurple,
        brightness: Brightness.light,
        surface: XColors.surfaceLight,
        onSurface: Colors.black,
        primary: XColors.primaryPurple,
        error: XColors.accentAlert,
      ),
      
      // Typography
      textTheme: _buildTextTheme(Brightness.light),
      
      // Components
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
      cardTheme: _buildCardTheme(Brightness.light),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
    );
  }

  // --- Helper Methods ---

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.dark ? Colors.white : Colors.black87;
    return TextTheme(
      // HEADINGS: Space Grotesk (Black, Tracking tight)
      displayLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w900, color: color, letterSpacing: -1),
      displayMedium: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5),
      displaySmall: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w700, color: color),
      
      // BODY: Poppins (Medium weight for readability)
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: color.withValues(alpha: 0.8)),
      
      // LABELS: Action / tracking heavy
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: color),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(Brightness brightness) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: XColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 12,
        shadowColor: XColors.primaryPurple.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16),
      ),
    );
  }

  static CardThemeData _buildCardTheme(Brightness brightness) {
    return CardThemeData(
      color: brightness == Brightness.dark ? XColors.surfaceDark : XColors.surfaceLight,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.3) : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.all(20),
      hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w400),
    );
  }
}
