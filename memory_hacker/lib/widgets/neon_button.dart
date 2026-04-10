import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        backgroundColor: AppTheme.accent.withValues(alpha: 0.16),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: BorderSide(color: AppTheme.accent.withValues(alpha: 0.45)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
