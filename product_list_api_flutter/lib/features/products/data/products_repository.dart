import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/product.dart';
import 'api_product.dart';
import 'product_list_response.dart';
import 'products_cache.dart';

class ProductsRepository {
  final http.Client _client;
  final ProductsCache _cache;

  ProductsRepository(this._client, this._cache);

  List<Product> mapToProducts(ProductListResponse r) =>
      r.products.map((p) => p.toProduct()).toList();

  Future<ProductListResponse> fetchProducts({int limit = 20, int skip = 0}) async {
    final uri = Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip');

    try {
      final res = await _client.get(uri);
      if (res.statusCode != 200) throw Exception('Failed: ${res.statusCode}');

      if (skip == 0) {
        await _cache.save(json: res.body, category: null, limit: limit);
      }

      final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
      return ProductListResponse.fromJson(jsonMap);
    } catch (e) {
      if (skip == 0) {
        final cached = _cache.load(category: null, limit: limit);
        if (cached != null) {
          final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
          return ProductListResponse.fromJson(jsonMap);
        }
      }
      rethrow;
    }
  }

  Future<List<String>> fetchCategorySlugs() async {
    final uri = Uri.parse('https://dummyjson.com/products/category-list');
    final res = await _client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load categories: ${res.statusCode}');
    }

    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => e.toString()).toList();
  }

  Future<ProductListResponse> fetchProductsByCategory({
    required String categorySlug,
    int limit = 20,
    int skip = 0,
  }) async {
    final slug = Uri.encodeComponent(categorySlug);
    final uri = Uri.parse(
      'https://dummyjson.com/products/category/$slug?limit=$limit&skip=$skip',
    );

    try {
      final res = await _client.get(uri);
      if (res.statusCode != 200) throw Exception('Failed: ${res.statusCode}');

      if (skip == 0) {
        await _cache.save(json: res.body, category: categorySlug, limit: limit);
      }

      final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
      return ProductListResponse.fromJson(jsonMap);
    } catch (e) {
      if (skip == 0) {
        final cached = _cache.load(category: categorySlug, limit: limit);
        if (cached != null) {
          final jsonMap = jsonDecode(cached) as Map<String, dynamic>;
          return ProductListResponse.fromJson(jsonMap);
        }
      }
      rethrow;
    }
  }

  Future<ProductListResponse> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  }) async {
    final q = Uri.encodeQueryComponent(query);
    final uri = Uri.parse(
      'https://dummyjson.com/products/search?q=$q&limit=$limit&skip=$skip',
    );

    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Search failed: ${res.statusCode}');
    }

    final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
    return ProductListResponse.fromJson(jsonMap);
  }

  Future<ApiProduct> fetchProductById(int id) async {
    final uri = Uri.parse('https://dummyjson.com/products/$id');
    final res = await _client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load product: ${res.statusCode}');
    }

    final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
    return ApiProduct.fromJson(jsonMap);
  }
}
