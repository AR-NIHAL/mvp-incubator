import 'package:flutter/foundation.dart';
import 'package:flame/components.dart';

import '../../components/grid/sequence_breach_grid_component.dart';
import '../../controllers/sequence_breach_scoring.dart';
import '../../models/sequence_breach_feedback_event.dart';
import '../../models/sequence_breach_feedback_type.dart';
import '../../models/sequence_breach_level_config.dart';
import '../../models/sequence_breach_phase.dart';
import '../../models/sequence_breach_result.dart';
import '../../models/sequence_breach_snapshot.dart';

class SequenceBreachSessionComponent extends Component {
  SequenceBreachSessionComponent({
    required this.config,
    required this.grid,
    required this.onSnapshotChanged,
    required this.onFeedback,
    required this.onFinished,
  });

  final SequenceBreachLevelConfig config;
  final SequenceBreachGridComponent grid;
  final ValueChanged<SequenceBreachSnapshot> onSnapshotChanged;
  final ValueChanged<SequenceBreachFeedbackEvent> onFeedback;
  final ValueChanged<SequenceBreachResult> onFinished;

  SequenceBreachPhase _phase = SequenceBreachPhase.booting;
  SequenceBreachPhase? _resumePhase;
  double _phaseTimer = 0;
  double _remainingInputTime = 0;
  double _elapsedSeconds = 0;
  int _playbackIndex = 0;
  int? _activePlaybackCell;
  int _inputIndex = 0;
  double _inputTapCooldown = 0;
  bool _resultSent = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    restart();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_phase == SequenceBreachPhase.paused) {
      return;
    }

    _elapsedSeconds += dt;
    if (_inputTapCooldown > 0) {
      _inputTapCooldown -= dt;
    }

    switch (_phase) {
      case SequenceBreachPhase.playback:
        _updatePlayback(dt);
        break;
      case SequenceBreachPhase.input:
        _updateInput(dt);
        break;
      case SequenceBreachPhase.booting:
      case SequenceBreachPhase.success:
      case SequenceBreachPhase.failure:
      case SequenceBreachPhase.paused:
        break;
    }
  }

  void restart() {
    _phase = SequenceBreachPhase.playback;
    _resumePhase = null;
    _phaseTimer = config.playbackLeadIn;
    _remainingInputTime = config.inputTimeLimit;
    _elapsedSeconds = 0;
    _playbackIndex = 0;
    _activePlaybackCell = null;
    _inputIndex = 0;
    _inputTapCooldown = 0;
    _resultSent = false;

    grid.resetBoard(inputEnabled: false);
    grid.pulsePrimed();
    _emitSnapshot('Watch the sequence');
  }

  void pause() {
    if (_phase == SequenceBreachPhase.success ||
        _phase == SequenceBreachPhase.failure) {
      return;
    }
    _resumePhase = _phase;
    _phase = SequenceBreachPhase.paused;
    grid.setInteractionEnabled(false);
    _emitSnapshot('Paused');
  }

  void resume() {
    if (_resumePhase == null) {
      return;
    }
    _phase = _resumePhase!;
    _resumePhase = null;
    grid.setInteractionEnabled(_phase == SequenceBreachPhase.input);
    _emitSnapshot(
      _phase == SequenceBreachPhase.input
          ? 'Repeat the sequence'
          : 'Replaying breach pattern',
    );
  }

  void handleCellPressed(int index) {
    if (_phase != SequenceBreachPhase.input) {
      return;
    }
    if (_inputTapCooldown > 0) {
      return;
    }

    final expectedIndex = config.sequence[_inputIndex];

    if (index == expectedIndex) {
      grid.flashCorrect(index);
      _inputTapCooldown = 0.1;
      _inputIndex += 1;
      if (_inputIndex >= config.sequence.length) {
        grid.flashSuccess();
        _emitFeedback(SequenceBreachFeedbackType.success);
        _setFinished(success: true, statusLabel: 'Sequence breach complete');
      } else {
        _emitFeedback(
          SequenceBreachFeedbackType.correctTap,
          stepIndex: _inputIndex - 1,
        );
        _emitSnapshot(
          'Correct. Continue ${_inputIndex + 1}/${config.sequence.length}',
        );
      }
      return;
    }

    grid.flashError(index);
    grid.flashFailure();
    _emitFeedback(SequenceBreachFeedbackType.wrongTap, stepIndex: _inputIndex);
    _setFinished(success: false, statusLabel: 'Trace mismatch detected');
  }

  void _updatePlayback(double dt) {
    _phaseTimer -= dt;
    if (_phaseTimer > 0) {
      return;
    }

    if (_activePlaybackCell != null) {
      grid.clearPlayback();
      _activePlaybackCell = null;
      _playbackIndex += 1;

      if (_playbackIndex >= config.sequence.length) {
        _beginInputPhase();
      } else {
        _phaseTimer = config.playbackGapDuration;
      }
      return;
    }

    if (_playbackIndex >= config.sequence.length) {
      _beginInputPhase();
      return;
    }

    _activePlaybackCell = config.sequence[_playbackIndex];
    grid.showPlaybackCell(_activePlaybackCell!);
    _phaseTimer = config.playbackHighlightDuration;
    _emitFeedback(
      SequenceBreachFeedbackType.playbackPulse,
      stepIndex: _playbackIndex,
    );
    _emitSnapshot('Memorize ${_playbackIndex + 1}/${config.sequence.length}');
  }

  void _beginInputPhase() {
    _phase = SequenceBreachPhase.input;
    _activePlaybackCell = null;
    _phaseTimer = 0;
    grid.resetBoard(inputEnabled: true);
    grid.pulseInputReady();
    _emitSnapshot('Repeat the sequence');
  }

  void _updateInput(double dt) {
    _remainingInputTime -= dt;
    if (_remainingInputTime <= 0) {
      _remainingInputTime = 0;
      _emitFeedback(SequenceBreachFeedbackType.failure);
      _setFinished(success: false, statusLabel: 'Signal timed out');
      return;
    }

    _emitSnapshot('Repeat the sequence');
  }

  void _setFinished({required bool success, required String statusLabel}) {
    _phase = success
        ? SequenceBreachPhase.success
        : SequenceBreachPhase.failure;
    grid.setInteractionEnabled(false);
    _emitSnapshot(statusLabel);

    if (_resultSent) {
      return;
    }

    _resultSent = true;
    onFinished(
      SequenceBreachResult(
        levelId: config.id,
        success: success,
        completedSteps: _inputIndex,
        totalSteps: config.sequence.length,
        elapsedSeconds: _elapsedSeconds,
        score: SequenceBreachScoring.calculateScore(
          success: success,
          completedSteps: _inputIndex,
          totalSteps: config.sequence.length,
          elapsedSeconds: _elapsedSeconds,
        ),
      ),
    );
  }

  void _emitFeedback(SequenceBreachFeedbackType type, {int? stepIndex}) {
    onFeedback(
      SequenceBreachFeedbackEvent(
        type: type,
        levelId: config.id,
        stepIndex: stepIndex,
      ),
    );
  }

  void _emitSnapshot(String statusLabel) {
    onSnapshotChanged(
      SequenceBreachSnapshot(
        phase: _phase,
        levelId: config.id,
        totalSteps: config.sequence.length,
        completedSteps: _inputIndex,
        remainingTime: _phase == SequenceBreachPhase.input
            ? _remainingInputTime
            : 0,
        statusLabel: statusLabel,
      ),
    );
  }
}
