import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../cells/sequence_breach_cell_component.dart';

enum SequenceBreachBoardState { neutral, primed, inputReady, success, failure }

class SequenceBreachGridComponent extends PositionComponent {
  SequenceBreachGridComponent({
    required this.gridSize,
    required this.onCellPressed,
  }) : super(anchor: Anchor.center);

  final int gridSize;
  final ValueChanged<int> onCellPressed;

  final List<SequenceBreachCellComponent> _cells = [];
  SequenceBreachBoardState _boardState = SequenceBreachBoardState.neutral;
  double _boardStateTimer = 0;
  double _boardStateDuration = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _buildCells();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_boardStateTimer <= 0) {
      return;
    }

    _boardStateTimer -= dt;
    if (_boardStateTimer <= 0) {
      _boardState = SequenceBreachBoardState.neutral;
      _boardStateDuration = 0;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final boardSize = (size.x * 0.82).clamp(220.0, 340.0).toDouble();
    this.size = Vector2.all(boardSize);
    position = size / 2;
    _layoutCells();
  }

  void setInteractionEnabled(bool enabled) {
    for (final cell in _cells) {
      cell.setInteractionEnabled(enabled);
    }
  }

  void showPlaybackCell(int index) {
    for (final cell in _cells) {
      cell.setPlaybackActive(cell.cellIndex == index);
    }
  }

  void clearPlayback() {
    for (final cell in _cells) {
      cell.resetVisual();
    }
  }

  void flashCorrect(int index) {
    _cells[index].flashCorrect();
  }

  void flashError(int index) {
    _cells[index].flashError();
  }

  void resetBoard({required bool inputEnabled}) {
    _boardState = inputEnabled
        ? SequenceBreachBoardState.inputReady
        : SequenceBreachBoardState.neutral;
    _boardStateTimer = inputEnabled ? 0.24 : 0;
    _boardStateDuration = _boardStateTimer;
    for (final cell in _cells) {
      cell.setInteractionEnabled(inputEnabled);
      cell.resetVisual();
    }
  }

  void pulsePrimed() {
    _setBoardState(SequenceBreachBoardState.primed, 0.28);
  }

  void pulseInputReady() {
    _setBoardState(SequenceBreachBoardState.inputReady, 0.32);
  }

  void flashSuccess() {
    _setBoardState(SequenceBreachBoardState.success, 0.7);
  }

  void flashFailure() {
    _setBoardState(SequenceBreachBoardState.failure, 0.75);
  }

  void _buildCells() {
    if (_cells.isNotEmpty) {
      return;
    }

    for (var index = 0; index < gridSize * gridSize; index++) {
      final cell = SequenceBreachCellComponent(
        cellIndex: index,
        onPressed: onCellPressed,
        position: Vector2.zero(),
        size: Vector2.zero(),
      );
      _cells.add(cell);
      add(cell);
    }
    _layoutCells();
  }

  void _layoutCells() {
    if (_cells.isEmpty || size.x == 0 || size.y == 0) {
      return;
    }

    const gap = 10.0;
    final totalGap = gap * (gridSize - 1);
    final cellExtent = (size.x - totalGap) / gridSize;

    for (final cell in _cells) {
      final row = cell.cellIndex ~/ gridSize;
      final column = cell.cellIndex % gridSize;
      cell.position = Vector2(
        column * (cellExtent + gap),
        row * (cellExtent + gap),
      );
      cell.size = Vector2.all(cellExtent);
    }
  }

  void _setBoardState(SequenceBreachBoardState state, double duration) {
    _boardState = state;
    _boardStateTimer = duration;
    _boardStateDuration = duration;
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(28),
    );
    final intensity = _boardStateDuration == 0
        ? 0.0
        : (_boardStateTimer / _boardStateDuration).clamp(0, 1).toDouble();

    final fillPaint = Paint()..color = const Color(0x55121A2B);
    final borderPaint = Paint()
      ..color =
          Color.lerp(const Color(0xFF29405F), _boardAccentColor, intensity) ??
          const Color(0xFF29405F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final glowPaint = Paint()
      ..color = _boardAccentColor.withValues(alpha: 0.22 * intensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawRRect(rect, fillPaint);
    if (intensity > 0.01) {
      canvas.drawRRect(rect, glowPaint);
    }
    canvas.drawRRect(rect, borderPaint);

    super.render(canvas);
  }

  Color get _boardAccentColor {
    switch (_boardState) {
      case SequenceBreachBoardState.primed:
        return const Color(0xFF00E5FF);
      case SequenceBreachBoardState.inputReady:
        return const Color(0xFFFF4FD8);
      case SequenceBreachBoardState.success:
        return const Color(0xFF7CFF6B);
      case SequenceBreachBoardState.failure:
        return const Color(0xFFFF5F6D);
      case SequenceBreachBoardState.neutral:
        return const Color(0xFF29405F);
    }
  }
}
