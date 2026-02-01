import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product.dart';
import 'products_providers.dart';
import 'search_providers.dart';

final searchResultsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productsRepositoryProvider);
  final q = ref.watch(debouncedQueryProvider);

  if (q.isEmpty) return const [];

  final res = await repo.searchProducts(query: q, limit: 20, skip: 0);
  return repo.mapToProducts(res);
});
