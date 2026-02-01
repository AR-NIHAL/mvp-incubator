import 'package:hive/hive.dart';

part 'cart_hive_models.g.dart';

@HiveType(typeId: 10)
class HiveCartItem extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String brand;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final int qty;

  HiveCartItem({
    required this.productId,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.qty,
  });

  HiveCartItem copyWith({int? qty}) {
    return HiveCartItem(
      productId: productId,
      title: title,
      brand: brand,
      imageUrl: imageUrl,
      price: price,
      rating: rating,
      qty: qty ?? this.qty,
    );
  }
}
