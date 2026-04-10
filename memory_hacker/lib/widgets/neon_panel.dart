import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NeonPanel extends StatelessWidget {
  const NeonPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppTheme.surfaceAlt, AppTheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
