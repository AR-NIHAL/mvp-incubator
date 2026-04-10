import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/local/local_storage_providers.dart';
import '../../../game/models/sequence_breach_result.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/cyber_panel.dart';
import '../../../shared/widgets/cyber_scaffold.dart';
import '../../../shared/widgets/primary_action_button.dart';
import '../../../shared/widgets/secondary_action_button.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/state_panel.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../game/providers/sequence_breach_level_catalog.dart';
import 'results_view_data.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({required this.levelId, super.key, this.latestResult});

  final String levelId;
  final SequenceBreachResult? latestResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressionAsync = ref.watch(progressionStateProvider);

    return progressionAsync.when(
      data: (progression) {
        final level = sequenceBreachLevelById(levelId);
        if (level == null) {
          return CyberScaffold(
            appBar: AppBar(title: const Text('Run Result')),
            child: StatePanel(
              title: 'Mission result unavailable',
              message:
                  'This mission id is invalid or no longer exists in the active catalog.',
              detail: Text(
                levelId.isEmpty ? 'No mission id provided.' : levelId,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              primaryAction: FilledButton(
                onPressed: () => context.go(AppRoutes.levels),
                child: const Text('Back To Mission Grid'),
              ),
            ),
          );
        }

        final result = latestResult ?? progression.resultFor(levelId);
        if (result == null) {
          return CyberScaffold(
            appBar: AppBar(title: const Text('Run Result')),
            child: StatePanel(
              title: 'No run recorded yet',
              message:
                  'Complete this mission once to unlock a real result summary, timing, and best-run context.',
              detail: Text(
                level.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              primaryAction: FilledButton(
                onPressed: () => context.go(AppRoutes.playLevel(level.id)),
                child: const Text('Launch Mission'),
              ),
              secondaryAction: SecondaryActionButton(
                label: 'Back To Mission Grid',
                icon: Icons.grid_view_rounded,
                onPressed: () => context.go(AppRoutes.levels),
              ),
            ),
          );
        }

        final viewData = buildResultsViewData(
          result: result,
          progression: progression,
        );
        final theme = Theme.of(context);

        return CyberScaffold(
          appBar: AppBar(
            title: const Text('Run Result'),
            actions: [
              AppIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                SectionTitle(
                  title: viewData.headline,
                  subtitle: viewData.outcomeSummary,
                  badge: StatusBadge(
                    label: viewData.statusLabel,
                    icon: result.success
                        ? Icons.verified_rounded
                        : Icons.warning_amber_rounded,
                    foregroundColor: result.success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  trailing: StatusBadge(
                    label: viewData.levelId,
                    foregroundColor: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                CyberPanel(
                  glowColor: result.success
                      ? AppColors.success
                      : AppColors.accentSecondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewData.levelTitle,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        result.success
                            ? 'Sequence completed'
                            : 'Sequence failed',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          _MetricCell(
                            label: 'Elapsed',
                            value: viewData.elapsedLabel,
                          ),
                          _MetricCell(
                            label: 'Score',
                            value: viewData.scoreLabel,
                          ),
                          _MetricCell(
                            label: 'Steps',
                            value: viewData.stepsLabel,
                          ),
                          _MetricCell(
                            label: 'Accuracy',
                            value: viewData.accuracyLabel,
                          ),
                          _MetricCell(
                            label: 'Result',
                            value: result.success ? 'Clear' : 'Fail',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CyberPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best result context',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        viewData.bestResultMessage,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CyberPanel(
                  glowColor: result.success
                      ? AppColors.success
                      : AppColors.accentSecondary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Progression', style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppSpacing.md),
                      _BreakdownRow(
                        label: 'Mission id',
                        value: viewData.levelId,
                      ),
                      _BreakdownRow(
                        label: 'Completed steps',
                        value: viewData.stepsLabel,
                      ),
                      _BreakdownRow(
                        label: 'Accuracy',
                        value: viewData.accuracyLabel,
                      ),
                      _BreakdownRow(label: 'Score', value: viewData.scoreLabel),
                      _BreakdownRow(
                        label: 'Elapsed time',
                        value: viewData.elapsedLabel,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        viewData.progressionMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: result.success
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryActionButton(
                  label: viewData.primaryActionLabel,
                  icon: viewData.showPrimaryAsNext
                      ? Icons.arrow_forward_rounded
                      : Icons.replay_rounded,
                  onPressed: () => context.go(
                    AppRoutes.playLevel(viewData.primaryActionLevelId),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryActionButton(
                  label: 'Replay Mission',
                  icon: Icons.replay_rounded,
                  onPressed: () => context.go(AppRoutes.playLevel(levelId)),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryActionButton(
                  label: 'Back To Mission Grid',
                  icon: Icons.grid_view_rounded,
                  onPressed: () => context.go(AppRoutes.levels),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
