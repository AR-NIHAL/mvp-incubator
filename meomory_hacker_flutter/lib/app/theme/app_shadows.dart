import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static List<BoxShadow> panelGlow({
    Color color = AppColors.accent,
    double alpha = 0.18,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: alpha),
        blurRadius: 36,
        offset: const Offset(0, 14),
      ),
    ];
  }

  static List<BoxShadow> softGlow({
    Color color = AppColors.accentSecondary,
    double alpha = 0.12,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: alpha),
        blurRadius: 28,
        spreadRadius: 2,
      ),
    ];
  }
}
