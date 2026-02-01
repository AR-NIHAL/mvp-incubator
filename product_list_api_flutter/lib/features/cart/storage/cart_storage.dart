import 'package:hive/hive.dart';
import 'cart_hive_models.dart';

class CartStorage {
  static const _boxName = 'cartBox';
  Box<HiveCartItem> get _box => Hive.box<HiveCartItem>(_boxName);

  List<HiveCartItem> load() => _box.values.toList();

  Future<void> saveAll(List<HiveCartItem> items) async {
    await _box.clear();
    for (final item in items) {
      await _box.put(item.productId, item);
    }
  }

  Future<void> clear() async => _box.clear();
}
