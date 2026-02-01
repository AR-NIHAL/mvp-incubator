import '../model/product.dart';

class ProductsState {
  final List<Product> items;
  final int total;
  final int skip;
  final int limit;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;
  final String? category;

  const ProductsState({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
    required this.isLoading,
    required this.isLoadingMore,
    required this.error,
    required this.category,
  });

  factory ProductsState.initial({int limit = 20}) => ProductsState(
        items: const [],
        total: 0,
        skip: 0,
        limit: limit,
        isLoading: true,
        isLoadingMore: false,
        error: null,
        category: null,
      );

  bool get hasMore => items.length < total;

  ProductsState copyWith({
    List<Product>? items,
    int? total,
    int? skip,
    int? limit,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
    String? category,
  }) {
    return ProductsState(
      items: items ?? this.items,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      category: category,
    );
  }
}
