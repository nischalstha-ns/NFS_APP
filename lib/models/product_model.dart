class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String brand;
  final List<String> images;
  final int stock;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.images,
    required this.stock,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      stock: map['stock'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'images': images,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}