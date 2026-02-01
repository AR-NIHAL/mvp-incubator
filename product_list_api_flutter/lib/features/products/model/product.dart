class Product {
  final int id;
  final String title;
  final String brand;
  final String imageUrl;
  final double price;
  final double rating;

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  Product copyWith({
    int? id,
    String? title,
    String? brand,
    String? imageUrl,
    double? price,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}
