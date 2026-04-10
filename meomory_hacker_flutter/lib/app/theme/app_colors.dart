import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0A0F1E);
  static const backgroundDeep = Color(0xFF070B15);
  static const backgroundElevated = Color(0xFF121A2B);
  static const surface = Color(0xFF162238);
  static const surfaceMuted = Color(0xFF1B2740);
  static const surfaceBright = Color(0xFF223454);
  static const glass = Color(0xA6162238);
  static const accent = Color(0xFF00E5FF);
  static const accentSecondary = Color(0xFFFF4FD8);
  static const accentTertiary = Color(0xFF7CFF6B);
  static const success = Color(0xFF7CFF6B);
  static const warning = Color(0xFFFFC857);
  static const error = Color(0xFFFF5F6D);
  static const textPrimary = Color(0xFFE6F1FF);
  static const textSecondary = Color(0xFF9FB4D9);
  static const textMuted = Color(0xFF7486A8);
  static const outline = Color(0xFF29405F);
  static const panelBorder = Color(0x663D5A85);
  static const divider = Color(0x334D6B96);

  static const backdropGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0F1E), Color(0xFF10182A), Color(0xFF070B15)],
  );
}
