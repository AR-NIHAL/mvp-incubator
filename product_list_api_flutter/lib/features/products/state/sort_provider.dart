import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProductSort {
  none,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
}

final productSortProvider = StateProvider<ProductSort>((ref) => ProductSort.none);
