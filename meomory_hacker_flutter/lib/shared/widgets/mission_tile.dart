import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import 'cyber_panel.dart';
import 'status_badge.dart';

class MissionTile extends StatelessWidget {
  const MissionTile({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.onTap,
    super.key,
    this.badge,
    this.trailingLabel,
    this.isLocked = false,
  });

  final String title;
  final String subtitle;
  final String meta;
  final VoidCallback onTap;
  final StatusBadge? badge;
  final String? trailingLabel;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: isLocked ? 0.72 : 1,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: CyberPanel(
          glowColor: isLocked ? AppColors.accentSecondary : AppColors.accent,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badge != null) ...[
                      badge!,
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      meta,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    isLocked ? Icons.lock_outline_rounded : Icons.arrow_outward,
                    color: isLocked ? AppColors.textMuted : AppColors.accent,
                  ),
                  if (trailingLabel != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadii.md),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Text(
                        trailingLabel!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
