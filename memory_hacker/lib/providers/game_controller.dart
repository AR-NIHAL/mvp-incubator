import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_progress.dart';
import '../models/game_state.dart';
import '../models/game_status.dart';
import '../models/level_config.dart';
import '../models/pattern_token.dart';
import '../services/pattern_generator_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../services/vibration_service.dart';
import 'app_providers.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  return GameController(
    generator: ref.watch(patternGeneratorProvider),
    storage: ref.watch(storageServiceProvider),
    soundService: ref.watch(soundServiceProvider),
    vibrationService: ref.watch(vibrationServiceProvider),
  )..loadProgress();
});

class GameController extends StateNotifier<GameState> {
  GameController({
    required PatternGeneratorService generator,
    required StorageService storage,
    required SoundService soundService,
    required VibrationService vibrationService,
  })  : _generator = generator,
        _storage = storage,
        _soundService = soundService,
        _vibrationService = vibrationService,
        super(GameState.initial());

  final PatternGeneratorService _generator;
  final StorageService _storage;
  final SoundService _soundService;
  final VibrationService _vibrationService;

  Timer? _countdownTimer;
  bool _busy = false;

  Future<void> loadProgress() async {
    final progress = await _storage.loadProgress();
    state = state.copyWith(
      highScore: progress.highScore,
      unlockedLevel: progress.unlockedLevel,
      soundEnabled: progress.soundEnabled,
      vibrationEnabled: progress.vibrationEnabled,
      message: 'Profile synced. Highest breach: ${progress.highScore}.',
    );
  }

  Future<void> startGame({int startLevel = 1}) async {
    _stopCountdown();
    state = state.copyWith(
      level: startLevel,
      score: 0,
      lives: 3,
      status: GameStatus.idle,
      message: 'Injecting sequence...',
    );
    await _startRound(levelOverride: startLevel);
  }

  Future<void> replayLevel() async {
    _stopCountdown();
    await _startRound(
      levelOverride: state.level,
      keepScore: true,
      keepLives: true,
    );
  }

  Future<void> selectToken(PatternToken token) async {
    if (!state.canInteract) {
      return;
    }

    await _soundService.playTap(enabled: state.soundEnabled);
    await _vibrationService.pulse(enabled: state.vibrationEnabled);

    final nextInput = [...state.userInput, token];
    final checkIndex = nextInput.length - 1;
    final expected = state.sequence[checkIndex];

    if (token != expected) {
      final remainingLives = state.lives - 1;
      await _soundService.playError(enabled: state.soundEnabled);
      await _vibrationService.error(enabled: state.vibrationEnabled);

      if (remainingLives <= 0) {
        await _endGame(
          'Security lockout. Sequence mismatch detected.',
          finalScore: state.score,
        );
        return;
      }

      state = state.copyWith(
        lives: remainingLives,
        userInput: const [],
        status: GameStatus.idle,
        message: 'Access denied. Replaying pattern. Lives left: $remainingLives',
      );

      await Future<void>.delayed(const Duration(milliseconds: 900));
      await _startRound(
        levelOverride: state.level,
        keepScore: true,
        keepLives: true,
      );
      return;
    }

    state = state.copyWith(
      userInput: nextInput,
      message: 'Correct signal ${nextInput.length}/${state.sequence.length}',
    );

    if (nextInput.length == state.sequence.length) {
      final earnedScore =
          state.score + (state.level * 125) + (state.timeRemaining * 10);
      final nextLevel = state.level + 1;
      final unlockedLevel =
          nextLevel > state.unlockedLevel ? nextLevel : state.unlockedLevel;
      final highScore = earnedScore > state.highScore ? earnedScore : state.highScore;

      state = state.copyWith(
        score: earnedScore,
        highScore: highScore,
        unlockedLevel: unlockedLevel,
        status: GameStatus.roundClear,
        message: 'System cracked. Escalating to level $nextLevel.',
      );

      await _persistProgress(
        highScore: highScore,
        unlockedLevel: unlockedLevel,
      );
      await _soundService.playSuccess(enabled: state.soundEnabled);

      await Future<void>.delayed(const Duration(milliseconds: 1100));
      await _startRound(
        levelOverride: nextLevel,
        keepScore: true,
        keepLives: true,
      );
    }
  }

  Future<void> updateSound(bool value) async {
    final progress = await _currentProgress();
    await _storage.saveProgress(progress.copyWith(soundEnabled: value));
    state = state.copyWith(
      soundEnabled: value,
      message: value ? 'Sound effects enabled.' : 'Sound effects muted.',
    );
  }

  Future<void> updateVibration(bool value) async {
    final progress = await _currentProgress();
    await _storage.saveProgress(progress.copyWith(vibrationEnabled: value));
    state = state.copyWith(
      vibrationEnabled: value,
      message: value ? 'Haptics enabled.' : 'Haptics muted.',
    );
  }

  Future<GameProgress> currentProgress() => _currentProgress();

  Future<void> _startRound({
    required int levelOverride,
    bool keepScore = false,
    bool keepLives = false,
  }) async {
    if (_busy) {
      return;
    }

    _busy = true;
    _stopCountdown();

    final config = _generator.getConfigForLevel(levelOverride);
    final sequence = _generator.buildSequence(config);
    final availableTokens = PatternToken.values
        .take(config.tokenCount)
        .toList(growable: false);

    state = state.copyWith(
      level: levelOverride,
      score: keepScore ? state.score : 0,
      lives: keepLives ? state.lives : 3,
      sequence: sequence,
      userInput: const [],
      activePreviewIndex: -1,
      availableTokens: availableTokens,
      timeRemaining: config.totalTimeSeconds,
      status: GameStatus.previewing,
      message: 'Memorize the incoming sequence.',
    );

    await _playPreview(config);

    if (state.isGameOver) {
      _busy = false;
      return;
    }

    state = state.copyWith(
      status: GameStatus.awaitingInput,
      activePreviewIndex: -1,
      userInput: const [],
      message: 'Repeat the sequence before time runs out.',
    );

    _startCountdown(config.totalTimeSeconds);
    _busy = false;
  }

  Future<void> _playPreview(LevelConfig config) async {
    for (var index = 0; index < state.sequence.length; index++) {
      state = state.copyWith(activePreviewIndex: index);
      await Future<void>.delayed(Duration(milliseconds: config.previewStepMs));
      state = state.copyWith(activePreviewIndex: -1);
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
  }

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    state = state.copyWith(timeRemaining: seconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.timeRemaining - 1;
      if (next <= 0) {
        timer.cancel();
        _handleTimeout();
        return;
      }
      state = state.copyWith(timeRemaining: next);
    });
  }

  Future<void> _handleTimeout() async {
    final remainingLives = state.lives - 1;
    if (remainingLives <= 0) {
      await _endGame(
        'Trace expired. You ran out of time.',
        finalScore: state.score,
      );
      return;
    }

    state = state.copyWith(
      lives: remainingLives,
      status: GameStatus.idle,
      userInput: const [],
      message: 'Timer depleted. Replaying level. Lives left: $remainingLives',
    );

    await _soundService.playError(enabled: state.soundEnabled);
    await _vibrationService.error(enabled: state.vibrationEnabled);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    await _startRound(
      levelOverride: state.level,
      keepScore: true,
      keepLives: true,
    );
  }

  Future<void> _endGame(String message, {required int finalScore}) async {
    _stopCountdown();
    final highScore = finalScore > state.highScore ? finalScore : state.highScore;
    await _persistProgress(
      highScore: highScore,
      unlockedLevel: state.unlockedLevel,
    );
    state = state.copyWith(
      highScore: highScore,
      status: GameStatus.gameOver,
      activePreviewIndex: -1,
      message: message,
    );
  }

  Future<void> _persistProgress({
    required int highScore,
    required int unlockedLevel,
  }) async {
    final progress = await _currentProgress();
    await _storage.saveProgress(
      progress.copyWith(
        highScore: highScore,
        unlockedLevel: unlockedLevel,
      ),
    );
  }

  Future<GameProgress> _currentProgress() async {
    final progress = await _storage.loadProgress();
    return progress.copyWith(
      highScore: state.highScore,
      unlockedLevel: state.unlockedLevel,
    );
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  void dispose() {
    _stopCountdown();
    super.dispose();
  }
}
