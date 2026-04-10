import 'game_status.dart';
import 'pattern_token.dart';

/// Immutable state consumed by Riverpod.
class GameState {
  const GameState({
    required this.level,
    required this.score,
    required this.lives,
    required this.highScore,
    required this.unlockedLevel,
    required this.status,
    required this.timeRemaining,
    required this.sequence,
    required this.userInput,
    required this.activePreviewIndex,
    required this.availableTokens,
    required this.message,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  factory GameState.initial() {
    return const GameState(
      level: 1,
      score: 0,
      lives: 3,
      highScore: 0,
      unlockedLevel: 1,
      status: GameStatus.idle,
      timeRemaining: 0,
      sequence: [],
      userInput: [],
      activePreviewIndex: -1,
      availableTokens: PatternToken.values,
      message: 'Boot sequence ready.',
      soundEnabled: true,
      vibrationEnabled: true,
    );
  }

  final int level;
  final int score;
  final int lives;
  final int highScore;
  final int unlockedLevel;
  final GameStatus status;
  final int timeRemaining;
  final List<PatternToken> sequence;
  final List<PatternToken> userInput;
  final int activePreviewIndex;
  final List<PatternToken> availableTokens;
  final String message;
  final bool soundEnabled;
  final bool vibrationEnabled;

  bool get canInteract => status == GameStatus.awaitingInput;
  bool get isGameOver => status == GameStatus.gameOver;

  GameState copyWith({
    int? level,
    int? score,
    int? lives,
    int? highScore,
    int? unlockedLevel,
    GameStatus? status,
    int? timeRemaining,
    List<PatternToken>? sequence,
    List<PatternToken>? userInput,
    int? activePreviewIndex,
    List<PatternToken>? availableTokens,
    String? message,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return GameState(
      level: level ?? this.level,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      highScore: highScore ?? this.highScore,
      unlockedLevel: unlockedLevel ?? this.unlockedLevel,
      status: status ?? this.status,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      sequence: sequence ?? this.sequence,
      userInput: userInput ?? this.userInput,
      activePreviewIndex: activePreviewIndex ?? this.activePreviewIndex,
      availableTokens: availableTokens ?? this.availableTokens,
      message: message ?? this.message,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
