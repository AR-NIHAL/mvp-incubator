import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextTheme textTheme() {
    const base = TextTheme();

    return base.copyWith(
      displayLarge: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.6,
        height: 1.05,
        color: AppColors.textPrimary,
      ),
      displayMedium: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      headlineMedium: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.textPrimary,
      ),
      headlineSmall: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: AppColors.textPrimary,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        height: 1.45,
        color: AppColors.textMuted,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.textSecondary,
      ),
    );
  }
}
