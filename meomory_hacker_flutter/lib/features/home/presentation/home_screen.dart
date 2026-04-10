import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/local/local_storage_providers.dart';
import '../../../game/models/sequence_breach_progression_state.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/cyber_panel.dart';
import '../../../shared/widgets/cyber_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/secondary_action_button.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/status_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progression = ref.watch(progressionStateProvider).valueOrNull;
    final latestLevelId = _latestResultLevelId(progression);

    return CyberScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const StatusBadge(
                  label: 'SYSTEM READY',
                  icon: Icons.shield_moon_outlined,
                ),
                const Spacer(),
                AppIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onPressed: () => context.push(AppRoutes.settings),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Hack the pattern.\nHold the signal.',
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'A mobile-first cyberpunk memory puzzler built with a clean Flutter shell and an isolated Flame gameplay layer. Sequence Breach is fully playable, with progression, local persistence, and reusable shell screens in place.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryActionButton(
              label: 'Start Mission',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go(AppRoutes.levels),
            ),
            const SizedBox(height: AppSpacing.sm),
            SecondaryActionButton(
              label: 'Replay First Mission',
              icon: Icons.videogame_asset_outlined,
              onPressed: () => context.go(AppRoutes.playLevel('boot-sequence')),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            const SectionTitle(
              title: 'Command deck',
              subtitle:
                  'Each destination below maps to a working MVP shell route with persistent local state.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _NavTile(
              title: 'Mission Grid',
              subtitle: 'Browse handcrafted levels and launch a run.',
              icon: Icons.grid_view_rounded,
              onTap: () => context.go(AppRoutes.levels),
            ),
            const SizedBox(height: AppSpacing.md),
            _NavTile(
              title: 'Latest Result',
              subtitle: latestLevelId == null
                  ? 'No mission has been completed yet. Launch a run to generate a saved result.'
                  : 'Jump back into the most recently saved mission result and progression summary.',
              icon: Icons.analytics_outlined,
              onTap: () => context.go(
                latestLevelId == null
                    ? AppRoutes.levels
                    : AppRoutes.resultLevel(latestLevelId),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _NavTile(
              title: 'Settings',
              subtitle:
                  'Check the shell-level accessibility and feedback toggles.',
              icon: Icons.tune_rounded,
              onTap: () => context.push(AppRoutes.settings),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            CyberPanel(
              glowColor: AppColors.accentSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    title: 'Foundation status',
                    subtitle:
                        'Flutter owns shell flow, presentation, and progression. Flame stays isolated inside the gameplay host area.',
                    badge: StatusBadge(
                      label: 'ARCHITECTURE',
                      icon: Icons.layers_outlined,
                      foregroundColor: AppColors.accentSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: const [
                      _MetaChip(label: 'GoRouter ready'),
                      _MetaChip(label: 'Riverpod bootstrapped'),
                      _MetaChip(label: 'Hive scaffolded'),
                      _MetaChip(label: 'Flame host isolated'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _latestResultLevelId(SequenceBreachProgressionState? progression) {
  if (progression == null) {
    return null;
  }

  String? latestLevelId;
  int latestTimestamp = -1;
  for (final entry in progression.bestResults.entries) {
    final completedAt = entry.value.completedAtEpochMs ?? 0;
    if (completedAt >= latestTimestamp) {
      latestTimestamp = completedAt;
      latestLevelId = entry.key;
    }
  }
  return latestLevelId;
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: CyberPanel(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline),
              ),
              child: Icon(icon, color: AppColors.accent),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Icon(Icons.arrow_outward_rounded, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
