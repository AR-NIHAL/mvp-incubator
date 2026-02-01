import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/favorites_storage.dart';

final favoritesStorageProvider = Provider<FavoritesStorage>((ref) => FavoritesStorage());

class FavoritesNotifier extends Notifier<Set<int>> {
  bool _hydrated = false;

  @override
  Set<int> build() {
    if (!_hydrated) {
      _hydrated = true;
      Future.microtask(_hydrate);
    }
    return <int>{};
  }

  Future<void> _hydrate() async {
    final ids = ref.read(favoritesStorageProvider).loadIds();
    state = ids.toSet();
  }

  Future<void> toggle(int productId) async {
    final newSet = {...state};
    if (newSet.contains(productId)) {
      newSet.remove(productId);
    } else {
      newSet.add(productId);
    }
    state = newSet;
    await ref.read(favoritesStorageProvider).setIds(state.toList());
  }

  Future<void> clear() async {
    state = <int>{};
    await ref.read(favoritesStorageProvider).clear();
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<int>>(FavoritesNotifier.new);
