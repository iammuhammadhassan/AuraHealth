import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkGlassTheme {
  const DarkGlassTheme._();

  static const Color deepMidnight = Color(0xFF0B0E11);
  static const Color electricCyan = Color(0xFF00F2FF);

  static ThemeData get theme {
    final baseTheme = FlexThemeData.dark(
      scheme: FlexScheme.custom,
      colors: const FlexSchemeColor(
        primary: electricCyan,
        primaryContainer: Color(0xFF005762),
        secondary: Color(0xFF66F8FF),
        secondaryContainer: Color(0xFF0A3D44),
        tertiary: Color(0xFF8BEFFF),
        tertiaryContainer: Color(0xFF164A53),
        appBarColor: deepMidnight,
        error: Color(0xFFFF6B6B),
      ),
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
      blendLevel: 20,
      scaffoldBackground: deepMidnight,
      appBarStyle: FlexAppBarStyle.surface,
      subThemesData: const FlexSubThemesData(
        blendOnColors: false,
        cardRadius: 20,
        defaultRadius: 14,
        elevatedButtonRadius: 14,
        outlinedButtonRadius: 14,
        inputDecoratorRadius: 14,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    );

    return baseTheme.copyWith(
      canvasColor: deepMidnight,
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.06),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: electricCyan.withOpacity(0.14)),
        ),
      ),
      dividerColor: electricCyan.withOpacity(0.22),
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: const Color(0xFF12161B),
      ),
    );
  }
}
