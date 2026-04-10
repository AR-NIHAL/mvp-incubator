import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_shadows.dart';

class CyberPanel extends StatelessWidget {
  const CyberPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
    this.glowColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: borderColor ?? AppColors.panelBorder),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xDD1A2741), Color(0xB2101827)],
        ),
        boxShadow: AppShadows.panelGlow(
          color: glowColor ?? AppColors.accent,
          alpha: 0.12,
        ),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
