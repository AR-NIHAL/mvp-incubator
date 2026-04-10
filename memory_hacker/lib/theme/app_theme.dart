import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF07111A);
  static const Color surface = Color(0xFF101C28);
  static const Color surfaceAlt = Color(0xFF152636);
  static const Color accent = Color(0xFF00F0FF);
  static const Color success = Color(0xFF39FF88);
  static const Color warning = Color(0xFFFFC857);
  static const Color danger = Color(0xFFFF4D6D);

  static ThemeData darkTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      primary: accent,
      secondary: success,
      surface: surface,
      error: danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'monospace',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.9),
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(height: 1.5),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
      ),
    );
  }
}
