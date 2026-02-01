import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../products/model/product.dart';
import '../model/cart_item.dart';
import '../storage/cart_hive_models.dart';
import '../storage/cart_storage.dart';

final cartStorageProvider = Provider<CartStorage>((ref) => CartStorage());

class CartNotifier extends Notifier<List<CartItem>> {
  bool _hydrated = false;

  @override
  List<CartItem> build() {
    if (!_hydrated) {
      _hydrated = true;
      Future.microtask(_hydrate);
    }
    return const [];
  }

  Future<void> _hydrate() async {
    final storage = ref.read(cartStorageProvider);
    final saved = storage.load();

    final items = saved.map((h) {
      final p = Product(
        id: h.productId,
        title: h.title,
        brand: h.brand,
        imageUrl: h.imageUrl,
        price: h.price,
        rating: h.rating,
      );
      return CartItem(product: p, qty: h.qty);
    }).toList();

    state = items;
  }

  Future<void> _persist() async {
    final storage = ref.read(cartStorageProvider);
    final hiveItems = state.map((c) {
      return HiveCartItem(
        productId: c.product.id,
        title: c.product.title,
        brand: c.product.brand,
        imageUrl: c.product.imageUrl,
        price: c.product.price,
        rating: c.product.rating,
        qty: c.qty,
      );
    }).toList();

    await storage.saveAll(hiveItems);
  }

  Future<void> add(Product p) async {
    final idx = state.indexWhere((x) => x.product.id == p.id);
    if (idx == -1) {
      state = [...state, CartItem(product: p, qty: 1)];
      await _persist();
      return;
    }
    final updated = state[idx].copyWith(qty: state[idx].qty + 1);
    final newList = [...state];
    newList[idx] = updated;
    state = newList;
    await _persist();
  }

  Future<void> removeOne(int productId) async {
    final idx = state.indexWhere((x) => x.product.id == productId);
    if (idx == -1) return;

    final item = state[idx];
    if (item.qty <= 1) {
      await removeItem(productId);
      return;
    }

    final updated = item.copyWith(qty: item.qty - 1);
    final newList = [...state];
    newList[idx] = updated;
    state = newList;

    await _persist();
  }

  Future<void> removeItem(int productId) async {
    state = state.where((x) => x.product.id != productId).toList();
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    await ref.read(cartStorageProvider).clear();
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  double sum = 0;
  for (final i in items) {
    sum += i.lineTotal;
  }
  return sum;
});

final cartCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  int c = 0;
  for (final i in items) {
    c += i.qty;
  }
  return c;
});
