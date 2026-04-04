import 'package:flutter/material.dart';

/// Xenia Constants - The "Source of Truth" for Geometry & Motion
class XeniaSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class XeniaRadius {
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0; // Standard for Xenia Cards/Modals
  static const double max = 99.0; // Buttons/Pills
}

class XeniaAnimation {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Curve curve = Curves.easeOutCubic;
}

class XeniaColors {
  // --- PRIMARY TONES ---
  static const Color purpleLight = Color(0xFF6200EE);
  static const Color purpleDark = Color(0xFFB026FF); 

  // --- DANGER & WARNING ---
  static const Color terminateRed = Color(0xFFE11D48);
  static const Color warningOrange = Color(0xFFFF512F);
  static const Color warningPink = Color(0xFFDD2476);
  
  // --- SURFACES (DARK) ---
  static const Color backgroundDark = Color(0xFF050505);
  static const Color surfaceDark = Color(0xFF111827); 
  static const Color surfaceSlate = Color(0xFF1E293B);

  // --- SURFACES (LIGHT) ---
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSlateLight = Color(0xFFE2E8F0);

  // --- TEXT ---
  static const Color textMainDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3B8);
  static const Color textMainLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);

  static LinearGradient get warningGradient => const LinearGradient(
    colors: [warningOrange, warningPink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class XeniaTheme {
  // --- TYPOGRAPHY HIERARCHY ---
  static TextTheme _buildTextTheme(Color color, {required bool isDisplayBold}) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: -2,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: -1,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 1.2,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: XeniaColors.purpleLight,
      scaffoldBackgroundColor: XeniaColors.backgroundLight,
      textTheme: _buildTextTheme(XeniaColors.textMainLight, isDisplayBold: true),
      colorScheme: const ColorScheme.light(
        primary: XeniaColors.purpleLight,
        secondary: XeniaColors.purpleLight,
        surface: XeniaColors.surfaceLight,
        error: XeniaColors.terminateRed,
        onPrimary: Colors.white,
        onSurface: XeniaColors.textMainLight,
        outline: XeniaColors.surfaceSlateLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: XeniaColors.textMainLight,
        ),
      ),
      elevatedButtonTheme: _elevatedButtonTheme(isDark: false),
      cardTheme: _cardTheme(isDark: false),
      bottomSheetTheme: _bottomSheetTheme(isDark: false),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: XeniaColors.purpleDark,
      scaffoldBackgroundColor: XeniaColors.backgroundDark,
      textTheme: _buildTextTheme(XeniaColors.textMainDark, isDisplayBold: true),
      colorScheme: const ColorScheme.dark(
        primary: XeniaColors.purpleDark,
        secondary: XeniaColors.purpleDark,
        surface: XeniaColors.surfaceDark,
        error: XeniaColors.terminateRed,
        onPrimary: Colors.black,
        onSurface: XeniaColors.textMainDark,
        outline: XeniaColors.surfaceSlate,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: XeniaColors.textMainDark,
        ),
      ),
      elevatedButtonTheme: _elevatedButtonTheme(isDark: true),
      cardTheme: _cardTheme(isDark: true),
      bottomSheetTheme: _bottomSheetTheme(isDark: true),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? XeniaColors.purpleDark : XeniaColors.purpleLight,
        foregroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: XeniaSpacing.m, 
          horizontal: XeniaSpacing.l,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(XeniaRadius.m),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          fontSize: 14,
        ),
      ),
    );
  }

  static CardThemeData _cardTheme({required bool isDark}) {
    return CardThemeData(
      color: isDark ? XeniaColors.surfaceDark : XeniaColors.surfaceLight,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(XeniaRadius.xxl),
        side: BorderSide(
          color: isDark 
              ? XeniaColors.textMutedDark.withAlpha(30) 
              : XeniaColors.surfaceSlateLight,
          width: 1.5,
        ),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme({required bool isDark}) {
    return BottomSheetThemeData(
      backgroundColor: isDark ? XeniaColors.surfaceDark : XeniaColors.surfaceLight,
      elevation: 0,
      showDragHandle: true,
      dragHandleColor: isDark ? XeniaColors.surfaceSlate : XeniaColors.surfaceSlateLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(XeniaRadius.xxl)),
      ),
    );
  }
}
