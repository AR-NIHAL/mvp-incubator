import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.unlocked,
    required this.onTap,
  });

  final int level;
  final bool unlocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.45,
      child: InkWell(
        onTap: unlocked ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.surface,
            border: Border.all(
              color: unlocked
                  ? AppTheme.accent.withValues(alpha: 0.35)
                  : Colors.white12,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                unlocked
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                color: unlocked ? AppTheme.success : Colors.white54,
              ),
              const SizedBox(height: 10),
              Text('Level $level', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
