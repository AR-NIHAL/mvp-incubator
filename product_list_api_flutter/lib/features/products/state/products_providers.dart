import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/products_cache.dart';
import '../data/products_repository.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final productsCacheProvider = Provider<ProductsCache>((ref) => ProductsCache());

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepository(
    ref.watch(httpClientProvider),
    ref.watch(productsCacheProvider),
  );
});
