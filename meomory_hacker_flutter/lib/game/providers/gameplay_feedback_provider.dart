import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/gameplay_feedback_service.dart';

final gameplayFeedbackServiceProvider = Provider<GameplayFeedbackService>((
  ref,
) {
  final service = GameplayFeedbackService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
