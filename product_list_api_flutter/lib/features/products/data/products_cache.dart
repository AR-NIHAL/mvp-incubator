import 'package:hive/hive.dart';

class ProductsCache {
  static const _boxName = 'productsCacheBox';
  Box<String> get _box => Hive.box<String>(_boxName);

  String _key({String? category, required int limit}) {
    final c = category ?? 'ALL';
    return 'products_$c_limit_$limit';
  }

  Future<void> save({required String json, String? category, required int limit}) async {
    await _box.put(_key(category: category, limit: limit), json);
  }

  String? load({String? category, required int limit}) {
    return _box.get(_key(category: category, limit: limit));
  }

  Future<void> clear() async => _box.clear();
}
