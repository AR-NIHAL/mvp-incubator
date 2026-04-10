import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../controllers/sequence_breach_game_controller.dart';
import '../models/sequence_breach_level_config.dart';
import '../models/sequence_breach_result.dart';
import 'memory_hacker_game.dart';

class MemoryHackerGameView extends StatefulWidget {
  const MemoryHackerGameView({
    required this.levelConfig,
    required this.gameController,
    required this.onFinished,
    super.key,
  });

  final SequenceBreachLevelConfig levelConfig;
  final SequenceBreachGameController gameController;
  final ValueChanged<SequenceBreachResult> onFinished;

  @override
  State<MemoryHackerGameView> createState() => _MemoryHackerGameViewState();
}

class _MemoryHackerGameViewState extends State<MemoryHackerGameView> {
  late MemoryHackerGame _game;

  @override
  void initState() {
    super.initState();
    _game = _createGame();
  }

  @override
  void didUpdateWidget(covariant MemoryHackerGameView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.levelConfig.id == widget.levelConfig.id &&
        oldWidget.gameController == widget.gameController) {
      return;
    }

    _game = _createGame();
  }

  MemoryHackerGame _createGame() {
    return MemoryHackerGame(
      levelConfig: widget.levelConfig,
      gameController: widget.gameController,
      onFinished: widget.onFinished,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: GameWidget(game: _game),
    );
  }
}
