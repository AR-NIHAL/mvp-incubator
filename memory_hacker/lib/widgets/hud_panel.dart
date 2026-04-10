import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'neon_panel.dart';
import 'stat_chip.dart';

class HudPanel extends StatelessWidget {
  const HudPanel({
    super.key,
    required this.level,
    required this.score,
    required this.lives,
    required this.timeLeft,
  });

  final int level;
  final int score;
  final int lives;
  final int timeLeft;

  @override
  Widget build(BuildContext context) {
    return NeonPanel(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          StatChip(label: 'LEVEL', value: '$level'),
          StatChip(label: 'SCORE', value: '$score', color: AppTheme.success),
          StatChip(label: 'LIVES', value: '$lives', color: AppTheme.danger),
          StatChip(label: 'TIME', value: '${timeLeft}s', color: AppTheme.warning),
        ],
      ),
    );
  }
}
