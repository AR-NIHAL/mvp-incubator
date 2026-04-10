import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

enum SequenceBreachCellVisualState { idle, playback, correct, error, disabled }

class SequenceBreachCellComponent extends PositionComponent with TapCallbacks {
  SequenceBreachCellComponent({
    required this.cellIndex,
    required this.onPressed,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.topLeft);

  final int cellIndex;
  final ValueChanged<int> onPressed;

  SequenceBreachCellVisualState _visualState =
      SequenceBreachCellVisualState.idle;
  double _flashTimer = 0;
  bool _interactionEnabled = false;

  void setInteractionEnabled(bool enabled) {
    _interactionEnabled = enabled;
    if (!enabled && _visualState == SequenceBreachCellVisualState.disabled) {
      return;
    }
    if (!enabled && _visualState == SequenceBreachCellVisualState.idle) {
      _visualState = SequenceBreachCellVisualState.disabled;
    } else if (enabled &&
        _visualState == SequenceBreachCellVisualState.disabled) {
      _visualState = SequenceBreachCellVisualState.idle;
    }
  }

  void setPlaybackActive(bool active) {
    _visualState = active
        ? SequenceBreachCellVisualState.playback
        : (_interactionEnabled
              ? SequenceBreachCellVisualState.idle
              : SequenceBreachCellVisualState.disabled);
    _flashTimer = 0;
  }

  void flashCorrect() {
    _visualState = SequenceBreachCellVisualState.correct;
    _flashTimer = 0.28;
  }

  void flashError() {
    _visualState = SequenceBreachCellVisualState.error;
    _flashTimer = 0.45;
  }

  void resetVisual() {
    _flashTimer = 0;
    _visualState = _interactionEnabled
        ? SequenceBreachCellVisualState.idle
        : SequenceBreachCellVisualState.disabled;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_flashTimer <= 0) {
      return;
    }

    _flashTimer -= dt;
    if (_flashTimer <= 0) {
      resetVisual();
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_interactionEnabled) {
      onPressed(cellIndex);
    }
    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(16),
    );

    final fillPaint = Paint()..color = _fillColor;
    final glowPaint = Paint()
      ..color = _glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _glowWidth;
    final borderPaint = Paint()
      ..color = _borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (_glowWidth > 0) {
      canvas.drawRRect(rect, glowPaint);
    }
    canvas.drawRRect(rect, fillPaint);
    canvas.drawRRect(rect, borderPaint);

    final corePaint = Paint()..color = _coreColor;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x * _coreRadiusFactor,
      corePaint,
    );
  }

  Color get _fillColor {
    switch (_visualState) {
      case SequenceBreachCellVisualState.playback:
        return const Color(0xCC00E5FF);
      case SequenceBreachCellVisualState.correct:
        return const Color(0xCC7CFF6B);
      case SequenceBreachCellVisualState.error:
        return const Color(0xCCFF5F6D);
      case SequenceBreachCellVisualState.disabled:
        return const Color(0x33121A2B);
      case SequenceBreachCellVisualState.idle:
        return const Color(0x55162238);
    }
  }

  Color get _borderColor {
    switch (_visualState) {
      case SequenceBreachCellVisualState.playback:
        return const Color(0xFF00E5FF);
      case SequenceBreachCellVisualState.correct:
        return const Color(0xFF7CFF6B);
      case SequenceBreachCellVisualState.error:
        return const Color(0xFFFF5F6D);
      case SequenceBreachCellVisualState.disabled:
        return const Color(0xFF29405F);
      case SequenceBreachCellVisualState.idle:
        return const Color(0xFF3D5A85);
    }
  }

  Color get _coreColor {
    switch (_visualState) {
      case SequenceBreachCellVisualState.playback:
        return const Color(0xFF07101E);
      case SequenceBreachCellVisualState.correct:
        return const Color(0xFF07101E);
      case SequenceBreachCellVisualState.error:
        return const Color(0xFF07101E);
      case SequenceBreachCellVisualState.disabled:
        return const Color(0xFF4A5A73);
      case SequenceBreachCellVisualState.idle:
        return const Color(0xFF00E5FF);
    }
  }

  Color get _glowColor {
    switch (_visualState) {
      case SequenceBreachCellVisualState.playback:
        return const Color(0xAA00E5FF);
      case SequenceBreachCellVisualState.correct:
        return const Color(0xAA7CFF6B);
      case SequenceBreachCellVisualState.error:
        return const Color(0xAAFF5F6D);
      case SequenceBreachCellVisualState.disabled:
      case SequenceBreachCellVisualState.idle:
        return Colors.transparent;
    }
  }

  double get _glowWidth {
    switch (_visualState) {
      case SequenceBreachCellVisualState.playback:
        return 6;
      case SequenceBreachCellVisualState.correct:
        return 5;
      case SequenceBreachCellVisualState.error:
        return 7;
      case SequenceBreachCellVisualState.disabled:
      case SequenceBreachCellVisualState.idle:
        return 0;
    }
  }

  double get _coreRadiusFactor {
    switch (_visualState) {
      case SequenceBreachCellVisualState.playback:
        return 0.14;
      case SequenceBreachCellVisualState.correct:
        return 0.12;
      case SequenceBreachCellVisualState.error:
        return 0.1;
      case SequenceBreachCellVisualState.disabled:
        return 0.06;
      case SequenceBreachCellVisualState.idle:
        return 0.08;
    }
  }
}
