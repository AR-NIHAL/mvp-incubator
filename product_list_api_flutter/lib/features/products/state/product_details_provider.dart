import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api_product.dart';
import 'products_providers.dart';

final productDetailsProvider = FutureProvider.family<ApiProduct, int>((ref, id) async {
  final repo = ref.watch(productsRepositoryProvider);
  return repo.fetchProductById(id);
});
