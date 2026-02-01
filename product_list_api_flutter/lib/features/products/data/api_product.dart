import '../model/product.dart';

class ApiProduct {
  final int id;
  final String title;
  final String description;
  final String brand;
  final String category;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;

  ApiProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.brand,
    required this.category,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List<dynamic>? ?? const <dynamic>[])
        .map((e) => e.toString())
        .toList();

    return ApiProduct(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      brand: (json['brand'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      thumbnail: (json['thumbnail'] ?? '') as String,
      images: images,
    );
  }

  Product toProduct() {
    return Product(
      id: id,
      title: title,
      brand: brand,
      imageUrl: thumbnail,
      price: price,
      rating: rating,
    );
  }
}
