import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_providers.dart';

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(productsRepositoryProvider);
  final cats = await repo.fetchCategorySlugs();
  cats.sort();
  return cats;
});
