import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSearchingProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');
final _stableQueryProvider = StateProvider<String>((ref) => '');

final debouncedQueryProvider = Provider<String>((ref) {
  final q = ref.watch(searchQueryProvider);

  final link = ref.keepAlive();
  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
    link.close();
  });

  final stable = ref.watch(_stableQueryProvider.notifier);

  timer?.cancel();
  timer = Timer(const Duration(milliseconds: 350), () {
    stable.state = q.trim();
  });

  return ref.watch(_stableQueryProvider);
});
