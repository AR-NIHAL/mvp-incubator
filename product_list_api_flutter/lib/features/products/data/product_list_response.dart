import 'api_product.dart';

class ProductListResponse {
  final List<ApiProduct> products;
  final int total;
  final int skip;
  final int limit;

  ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final items = (json['products'] as List<dynamic>? ?? [])
        .map((e) => ApiProduct.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductListResponse(
      products: items,
      total: (json['total'] ?? 0) as int,
      skip: (json['skip'] ?? 0) as int,
      limit: (json['limit'] ?? items.length) as int,
    );
  }
}
