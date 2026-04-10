import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

class CyberScaffold extends StatelessWidget {
  const CyberScaffold({
    required this.child,
    super.key,
    this.appBar,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPadding,
      vertical: AppSpacing.md,
    ),
    this.bottomNavigationBar,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry padding;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: appBar != null,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.backdropGradient),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const _GlowLayer(),
            const _GridTexture(),
            SafeArea(
              child: Padding(padding: padding, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowLayer extends StatelessWidget {
  const _GlowLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -40,
          child: _GlowOrb(
            color: AppColors.accent.withValues(alpha: 0.18),
            size: 240,
          ),
        ),
        Positioned(
          bottom: 120,
          left: -60,
          child: _GlowOrb(
            color: AppColors.accentSecondary.withValues(alpha: 0.10),
            size: 220,
          ),
        ),
      ],
    );
  }
}

class _GridTexture extends StatelessWidget {
  const _GridTexture();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _GridPainter()));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withValues(alpha: 0.16)
      ..strokeWidth = 1;

    const spacing = 32.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 80, spreadRadius: 24),
          ],
        ),
        child: SizedBox.square(dimension: size),
      ),
    );
  }
}
