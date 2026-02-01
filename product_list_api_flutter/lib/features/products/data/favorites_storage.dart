import 'package:hive/hive.dart';

class FavoritesStorage {
  static const _boxName = 'favoritesBox';
  Box<int> get _box => Hive.box<int>(_boxName);

  List<int> loadIds() => _box.values.toList();

  Future<void> setIds(List<int> ids) async {
    await _box.clear();
    for (final id in ids) {
      await _box.add(id);
    }
  }

  Future<void> clear() async => _box.clear();
}
