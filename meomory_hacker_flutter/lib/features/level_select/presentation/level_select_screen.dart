import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/local/local_storage_providers.dart';
import '../../../game/providers/sequence_breach_level_catalog.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/cyber_scaffold.dart';
import '../../../shared/widgets/mission_tile.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/status_badge.dart';

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressionAsync = ref.watch(progressionStateProvider);

    return CyberScaffold(
      appBar: AppBar(
        title: const Text('Mission Grid'),
        actions: [
          AppIconButton(
            icon: Icons.settings_outlined,
            tooltip: 'Settings',
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 72),
          SectionTitle(
            title: 'Choose the next breach',
            subtitle:
                'Sequence Breach ramps gradually across ten handcrafted missions with persistent unlocks and replayable best results.',
            badge: const StatusBadge(
              label: 'MVP LEVELS',
              icon: Icons.grid_view_rounded,
            ),
            trailing: AppIconButton(
              icon: Icons.home_outlined,
              tooltip: 'Home',
              onPressed: () => context.go(AppRoutes.home),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Expanded(
            child: progressionAsync.when(
              data: (progression) {
                return ListView.separated(
                  itemCount: allSequenceBreachLevels.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final level = allSequenceBreachLevels[index];
                    final bestResult = progression.resultFor(level.id);
                    final isLocked = !progression.isUnlocked(level.id);
                    final bestLabel = bestResult == null
                        ? 'Best none'
                        : 'Best ${bestResult.completedSteps}/${level.sequence.length}';

                    return MissionTile(
                      title: '${index + 1}. ${level.title}',
                      subtitle: level.subtitle,
                      meta:
                          '${level.gridLabel} - ${level.difficultyLabel} - $bestLabel',
                      isLocked: isLocked,
                      badge: StatusBadge(
                        label: isLocked
                            ? 'LOCKED'
                            : bestResult == null
                            ? 'NEW NODE'
                            : level.difficultyLabel,
                        icon: isLocked
                            ? Icons.lock_outline_rounded
                            : bestResult == null
                            ? Icons.auto_awesome_rounded
                            : Icons.memory_rounded,
                        foregroundColor: isLocked
                            ? AppColors.textMuted
                            : bestResult == null
                            ? AppColors.accentSecondary
                            : AppColors.accent,
                      ),
                      trailingLabel: isLocked
                          ? 'Locked'
                          : bestResult == null
                          ? 'Launch'
                          : 'Replay',
                      onTap: () => context.go(AppRoutes.playLevel(level.id)),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
