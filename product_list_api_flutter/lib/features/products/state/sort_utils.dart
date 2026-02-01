import '../model/product.dart';
import 'sort_provider.dart';

List<Product> applySort(List<Product> items, ProductSort sort) {
  final list = [...items];
  switch (sort) {
    case ProductSort.none:
      return list;
    case ProductSort.priceLowToHigh:
      list.sort((a, b) => a.price.compareTo(b.price));
      return list;
    case ProductSort.priceHighToLow:
      list.sort((a, b) => b.price.compareTo(a.price));
      return list;
    case ProductSort.ratingHighToLow:
      list.sort((a, b) => b.rating.compareTo(a.rating));
      return list;
  }
}
