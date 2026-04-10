import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../data/local/local_storage_providers.dart';
import '../../../game/controllers/sequence_breach_game_controller.dart';
import '../../../game/engine/memory_hacker_game_view.dart';
import '../../../game/models/settings_state.dart';
import '../../../game/models/sequence_breach_feedback_event.dart';
import '../../../game/models/sequence_breach_level_config.dart';
import '../../../game/models/sequence_breach_phase.dart';
import '../../../game/models/sequence_breach_result.dart';
import '../../../game/models/sequence_breach_snapshot.dart';
import '../../../game/providers/gameplay_feedback_provider.dart';
import '../../../game/providers/sequence_breach_level_catalog.dart';
import '../../../shared/widgets/app_icon_button.dart';
import '../../../shared/widgets/cyber_panel.dart';
import '../../../shared/widgets/cyber_scaffold.dart';
import '../../../shared/widgets/secondary_action_button.dart';
import '../../../shared/widgets/state_panel.dart';
import '../../../shared/widgets/status_badge.dart';

enum _PauseAction { resume, restart, quit }

class GameplayShellScreen extends ConsumerStatefulWidget {
  const GameplayShellScreen({required this.levelId, super.key});

  final String levelId;

  @override
  ConsumerState<GameplayShellScreen> createState() =>
      _GameplayShellScreenState();
}

class _GameplayShellScreenState extends ConsumerState<GameplayShellScreen> {
  SequenceBreachLevelConfig? _levelConfig;
  SequenceBreachGameController? _gameController;
  SequenceBreachResult? _latestResult;
  StreamSubscription<SequenceBreachFeedbackEvent>? _feedbackSubscription;
  bool _tutorialDismissed = false;

  @override
  void initState() {
    super.initState();
    _configureLevel(widget.levelId);
  }

  @override
  void didUpdateWidget(covariant GameplayShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.levelId == widget.levelId) {
      return;
    }

    _latestResult = null;
    _tutorialDismissed = false;
    _configureLevel(widget.levelId);
  }

  void _configureLevel(String levelId) {
    _feedbackSubscription?.cancel();
    _gameController?.dispose();
    ref.read(gameplayFeedbackServiceProvider).resetSessionFeedback();
    _levelConfig = sequenceBreachLevelById(levelId);
    if (_levelConfig != null) {
      _gameController = SequenceBreachGameController(
        initialSnapshot: SequenceBreachSnapshot.initial(
          levelId: _levelConfig!.id,
          totalSteps: _levelConfig!.sequence.length,
        ),
      );
      _feedbackSubscription = _gameController!.feedbackEvents.listen(
        _handleFeedbackEvent,
      );
      return;
    }

    _gameController = null;
  }

  @override
  void dispose() {
    _feedbackSubscription?.cancel();
    _gameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levelConfig = _levelConfig;
    final gameController = _gameController;

    if (levelConfig == null || gameController == null) {
      return CyberScaffold(
        child: StatePanel(
          title: 'Mission unavailable',
          message:
              'This mission id is invalid or no longer exists in the current catalog.',
          detail: Text(
            widget.levelId.isEmpty ? 'No mission id provided.' : widget.levelId,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          primaryAction: FilledButton(
            onPressed: () => context.go(AppRoutes.levels),
            child: const Text('Back To Mission Grid'),
          ),
        ),
      );
    }

    final settingsAsync = ref.watch(settingsStateProvider);
    final settings = settingsAsync.valueOrNull;
    final showTutorial =
        settings != null &&
        !settings.sequenceBreachTutorialSeen &&
        !_tutorialDismissed;
    final theme = Theme.of(context);

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleQuitRequested();
        }
      },
      child: CyberScaffold(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.lg,
        ),
        child: ValueListenableBuilder<SequenceBreachSnapshot>(
          valueListenable: gameController,
          builder: (context, snapshot, _) {
            return Column(
              children: [
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    AppIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Quit',
                      onPressed: _handleQuitRequested,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            levelConfig.title.toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Sequence Breach',
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    AppIconButton(
                      icon: Icons.pause_rounded,
                      tooltip: 'Pause',
                      onPressed:
                          showTutorial ||
                              settingsAsync.isLoading ||
                              snapshot.isFinished
                          ? null
                          : () => _handlePauseRequested(gameController),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _HudRow(
                  phaseLabel: showTutorial
                      ? 'Tutorial'
                      : _phaseLabel(snapshot.phase),
                  progressLabel:
                      '${snapshot.completedSteps}/${snapshot.totalSteps}',
                  timerLabel: snapshot.phase == SequenceBreachPhase.input
                      ? snapshot.remainingTime.toStringAsFixed(1)
                      : '--',
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(
                    label: showTutorial
                        ? 'Watch. Remember. Repeat.'
                        : snapshot.statusLabel,
                    icon: showTutorial
                        ? Icons.school_rounded
                        : _statusIcon(snapshot.phase),
                    foregroundColor: showTutorial
                        ? AppColors.accentSecondary
                        : _statusColor(snapshot.phase),
                    backgroundColor: AppColors.background.withValues(
                      alpha: 0.72,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: CyberPanel(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    glowColor: showTutorial
                        ? AppColors.accentSecondary
                        : _statusColor(snapshot.phase),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildBoardArea(
                          settingsAsync: settingsAsync,
                          showTutorial: showTutorial,
                          settings: settings,
                          levelConfig: levelConfig,
                          gameController: gameController,
                        ),
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: StatusBadge(
                            label: showTutorial ? 'TUTORIAL' : '3x3 GRID',
                            icon: showTutorial
                                ? Icons.lightbulb_outline_rounded
                                : Icons.grid_view_rounded,
                            foregroundColor: showTutorial
                                ? AppColors.accentSecondary
                                : AppColors.accent,
                            backgroundColor: AppColors.background.withValues(
                              alpha: 0.82,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _ActionRow(
                  onQuit: _handleQuitRequested,
                  onRestart: showTutorial ? null : _restartLevel,
                  onResult: _latestResult != null
                      ? () => _goToResults(context, _latestResult!)
                      : null,
                  latestResult: _latestResult,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBoardArea({
    required AsyncValue<SettingsState> settingsAsync,
    required bool showTutorial,
    required SettingsState? settings,
    required SequenceBreachLevelConfig levelConfig,
    required SequenceBreachGameController gameController,
  }) {
    if (settingsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (showTutorial && settings != null) {
      return _TutorialCard(
        onStart: () => _completeTutorial(settings),
        onSkip: () => _completeTutorial(settings),
      );
    }

    return MemoryHackerGameView(
      levelConfig: levelConfig,
      gameController: gameController,
      onFinished: _handleGameFinished,
    );
  }

  Future<void> _completeTutorial(SettingsState settings) async {
    await ref
        .read(settingsRepositoryProvider)
        .saveSettings(settings.copyWith(sequenceBreachTutorialSeen: true));
    ref.invalidate(settingsStateProvider);

    if (!mounted) {
      return;
    }

    setState(() {
      _tutorialDismissed = true;
    });
  }

  void _restartLevel() {
    setState(() {
      _latestResult = null;
    });
    ref.read(gameplayFeedbackServiceProvider).resetSessionFeedback();
    _gameController?.restartLevel();
  }

  Future<void> _handleGameFinished(SequenceBreachResult result) async {
    final persistedResult = result.copyWith(
      completedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
    );

    await ref
        .read(progressionRepositoryProvider)
        .recordResult(
          result: persistedResult,
          catalog: allSequenceBreachLevels,
        );
    ref.invalidate(progressionStateProvider);

    if (!mounted) {
      return;
    }

    setState(() {
      _latestResult = persistedResult;
    });

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          persistedResult.success
              ? 'Sequence cracked. The next mission is now available.'
              : 'Sequence failed. Review the result or restart the breach.',
        ),
      ),
    );
  }

  Future<void> _handleFeedbackEvent(SequenceBreachFeedbackEvent event) async {
    final settings = ref.read(settingsStateProvider).valueOrNull;
    if (settings == null) {
      return;
    }

    await ref
        .read(gameplayFeedbackServiceProvider)
        .handleEvent(event: event, settings: settings);
  }

  Future<void> _handlePauseRequested(
    SequenceBreachGameController gameController,
  ) async {
    gameController.pauseGame();
    final action = await _showPauseSheet();

    if (!mounted) {
      return;
    }

    switch (action) {
      case _PauseAction.restart:
        _restartLevel();
        break;
      case _PauseAction.quit:
        final shouldQuit = await _confirmQuit();
        if (shouldQuit && mounted) {
          context.go(AppRoutes.levels);
        } else {
          gameController.resumeGame();
        }
        break;
      case _PauseAction.resume:
      case null:
        gameController.resumeGame();
        break;
    }
  }

  Future<void> _handleQuitRequested() async {
    final shouldQuit = await _confirmQuit();
    if (!mounted || !shouldQuit) {
      return;
    }
    context.go(AppRoutes.levels);
  }

  void _goToResults(BuildContext context, SequenceBreachResult result) {
    context.go(AppRoutes.resultLevel(result.levelId), extra: result);
  }

  Future<_PauseAction?> _showPauseSheet() {
    return showModalBottomSheet<_PauseAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: CyberPanel(
            glowColor: AppColors.accentSecondary,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StatusBadge(
                    label: 'PAUSED',
                    icon: Icons.pause_circle_outline_rounded,
                    foregroundColor: AppColors.accentSecondary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Sequence Breach paused',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Resume to continue, restart for a clean replay, or quit back to the mission grid.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_PauseAction.resume),
                    child: const Text('Resume'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryActionButton(
                    label: 'Restart Level',
                    icon: Icons.replay_rounded,
                    onPressed: () =>
                        Navigator.of(context).pop(_PauseAction.restart),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryActionButton(
                    label: 'Quit Mission',
                    icon: Icons.logout_rounded,
                    onPressed: () =>
                        Navigator.of(context).pop(_PauseAction.quit),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmQuit() async {
    if (_latestResult != null) {
      return true;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Quit current mission?'),
          content: const Text(
            'Your current run will be lost. Restarting from level select will replay the full sequence.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Quit'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  String _phaseLabel(SequenceBreachPhase phase) {
    switch (phase) {
      case SequenceBreachPhase.booting:
        return 'Ready';
      case SequenceBreachPhase.playback:
        return 'Watch';
      case SequenceBreachPhase.input:
        return 'Repeat';
      case SequenceBreachPhase.success:
        return 'Success';
      case SequenceBreachPhase.failure:
        return 'Failure';
      case SequenceBreachPhase.paused:
        return 'Paused';
    }
  }

  IconData _statusIcon(SequenceBreachPhase phase) {
    switch (phase) {
      case SequenceBreachPhase.booting:
        return Icons.memory_rounded;
      case SequenceBreachPhase.playback:
        return Icons.visibility_rounded;
      case SequenceBreachPhase.input:
        return Icons.touch_app_rounded;
      case SequenceBreachPhase.success:
        return Icons.verified_rounded;
      case SequenceBreachPhase.failure:
        return Icons.warning_amber_rounded;
      case SequenceBreachPhase.paused:
        return Icons.pause_circle_outline_rounded;
    }
  }

  Color _statusColor(SequenceBreachPhase phase) {
    switch (phase) {
      case SequenceBreachPhase.success:
        return AppColors.success;
      case SequenceBreachPhase.failure:
        return AppColors.error;
      case SequenceBreachPhase.paused:
        return AppColors.accentSecondary;
      case SequenceBreachPhase.booting:
      case SequenceBreachPhase.playback:
      case SequenceBreachPhase.input:
        return AppColors.accent;
    }
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CyberPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _HudRow extends StatelessWidget {
  const _HudRow({
    required this.phaseLabel,
    required this.progressLabel,
    required this.timerLabel,
  });

  final String phaseLabel;
  final String progressLabel;
  final String timerLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;
        if (isCompact) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _HudChip(label: 'Phase', value: phaseLabel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _HudChip(label: 'Progress', value: progressLabel),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _HudChip(label: 'Timer', value: timerLabel),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _HudChip(label: 'Phase', value: phaseLabel),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _HudChip(label: 'Progress', value: progressLabel),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _HudChip(label: 'Timer', value: timerLabel),
            ),
          ],
        );
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.onQuit,
    required this.onRestart,
    required this.onResult,
    required this.latestResult,
  });

  final VoidCallback onQuit;
  final VoidCallback? onRestart;
  final VoidCallback? onResult;
  final SequenceBreachResult? latestResult;

  @override
  Widget build(BuildContext context) {
    final resultLabel = (latestResult?.success ?? false) ? 'Next' : 'Result';
    final resultIcon = (latestResult?.success ?? false)
        ? Icons.arrow_forward_rounded
        : Icons.analytics_outlined;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 380;
        if (isCompact) {
          return Column(
            children: [
              SecondaryActionButton(
                label: 'Quit',
                icon: Icons.logout_rounded,
                onPressed: onQuit,
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryActionButton(
                label: 'Restart',
                icon: Icons.replay_rounded,
                onPressed: onRestart,
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onResult,
                  icon: Icon(resultIcon),
                  label: Text(resultLabel),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: SecondaryActionButton(
                label: 'Quit',
                icon: Icons.logout_rounded,
                onPressed: onQuit,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SecondaryActionButton(
                label: 'Restart',
                icon: Icons.replay_rounded,
                onPressed: onRestart,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton.icon(
                onPressed: onResult,
                icon: Icon(resultIcon),
                label: Text(resultLabel),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({required this.onStart, required this.onSkip});

  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: CyberPanel(
          glowColor: AppColors.accentSecondary,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusBadge(
                  label: 'FIRST RUN',
                  icon: Icons.school_rounded,
                  foregroundColor: AppColors.accentSecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Watch. Remember. Repeat.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'The board will play a sequence of highlighted cells. Once it clears, tap the same cells back in the exact order.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                const _TutorialStep(
                  index: '1',
                  title: 'Watch',
                  body:
                      'Track the highlighted path as it plays across the grid.',
                ),
                const SizedBox(height: AppSpacing.sm),
                const _TutorialStep(
                  index: '2',
                  title: 'Remember',
                  body: 'Hold the full order in memory after the board resets.',
                ),
                const SizedBox(height: AppSpacing.sm),
                const _TutorialStep(
                  index: '3',
                  title: 'Repeat',
                  body: 'Tap the same sequence back before the timer expires.',
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: onStart,
                  child: const Text('Start Guided Run'),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryActionButton(
                  label: 'Skip Tips',
                  icon: Icons.skip_next_rounded,
                  onPressed: onSkip,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TutorialStep extends StatelessWidget {
  const _TutorialStep({
    required this.index,
    required this.title,
    required this.body,
  });

  final String index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.55),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline),
          ),
          child: Text(index, style: Theme.of(context).textTheme.labelMedium),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xxs),
              Text(body, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
