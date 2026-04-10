import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/grid/sequence_breach_grid_component.dart';
import '../controllers/sequence_breach_game_controller.dart';
import '../mechanics/sequence_breach/sequence_breach_session_component.dart';
import '../models/sequence_breach_level_config.dart';
import '../models/sequence_breach_result.dart';
import '../models/sequence_breach_snapshot.dart';

class MemoryHackerGame extends FlameGame {
  MemoryHackerGame({
    required this.levelConfig,
    required this.gameController,
    required this.onFinished,
  });

  final SequenceBreachLevelConfig levelConfig;
  final SequenceBreachGameController gameController;
  final ValueChanged<SequenceBreachResult> onFinished;

  late final SequenceBreachGridComponent _grid;
  late final SequenceBreachSessionComponent _session;

  @override
  Color backgroundColor() => const Color(0xFF0A0F1E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _grid = SequenceBreachGridComponent(
      gridSize: levelConfig.gridSize,
      onCellPressed: _handleCellPressed,
    );

    _session = SequenceBreachSessionComponent(
      config: levelConfig,
      grid: _grid,
      onSnapshotChanged: gameController.updateSnapshot,
      onFeedback: gameController.emitFeedback,
      onFinished: onFinished,
    );

    add(_grid);
    add(_session);

    gameController.bind(
      restartAction: restartLevel,
      pauseAction: pauseLevel,
      resumeAction: resumeLevel,
    );

    gameController.updateSnapshot(
      SequenceBreachSnapshot.initial(
        levelId: levelConfig.id,
        totalSteps: levelConfig.sequence.length,
      ),
    );
  }

  void restartLevel() {
    _session.restart();
    if (paused) {
      resumeEngine();
    }
  }

  void pauseLevel() {
    _session.pause();
    pauseEngine();
  }

  void resumeLevel() {
    if (paused) {
      resumeEngine();
    }
    _session.resume();
  }

  void _handleCellPressed(int cellIndex) {
    _session.handleCellPressed(cellIndex);
  }
}
