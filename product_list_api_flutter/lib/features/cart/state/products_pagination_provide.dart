import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_state.dart';
import 'products_providers.dart';

class ProductsNotifier extends Notifier<ProductsState> {
  @override
  ProductsState build() {
    final s = ProductsState.initial(limit: 20);
    Future.microtask(_loadInitial);
    return s;
  }

  Future<void> _loadInitial() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repo = ref.read(productsRepositoryProvider);
      final res = (state.category == null)
          ? await repo.fetchProducts(limit: state.limit, skip: 0)
          : await repo.fetchProductsByCategory(
              categorySlug: state.category!,
              limit: state.limit,
              skip: 0,
            );

      final items = repo.mapToProducts(res);

      state = state.copyWith(
        items: items,
        total: res.total,
        skip: res.skip,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() async => _loadInitial();

  Future<void> setCategory(String? slug) async {
    state = state.copyWith(category: slug);
    await _loadInitial();
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore) return;
    if (!state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final repo = ref.read(productsRepositoryProvider);
      final nextSkip = state.items.length;

      final res = (state.category == null)
          ? await repo.fetchProducts(limit: state.limit, skip: nextSkip)
          : await repo.fetchProductsByCategory(
              categorySlug: state.category!,
              limit: state.limit,
              skip: nextSkip,
            );

      final newItems = repo.mapToProducts(res);

      state = state.copyWith(
        items: [...state.items, ...newItems],
        total: res.total,
        skip: res.skip,
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }
}

final productsNotifierProvider =
    NotifierProvider<ProductsNotifier, ProductsState>(ProductsNotifier.new);
