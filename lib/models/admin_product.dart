class AdminProduct {
  String id;
  String name;
  String category;
  double price;
  String status;
  int stock;
  String brand;
  List<String> sizes;
  List<String> colors;
  List<String> images;

  AdminProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.status,
    required this.stock,
    required this.brand,
    required this.sizes,
    required this.colors,
    required this.images,
  });

  factory AdminProduct.fromMap(String id, Map<dynamic, dynamic> map) {
    return AdminProduct(
      id: id,
      name: (map['name'] ?? '') as String,
      category: (map['category'] ?? '') as String,
      price: (map['price'] != null) ? double.tryParse(map['price'].toString()) ?? 0 : 0,
      status: (map['status'] ?? 'Inactive') as String,
      stock: (map['stock'] != null) ? int.tryParse(map['stock'].toString()) ?? 0 : 0,
      brand: (map['brand'] ?? '') as String,
      sizes: (map['sizes'] != null) ? List<String>.from(map['sizes']) : <String>[],
      colors: (map['colors'] != null) ? List<String>.from(map['colors']) : <String>[],
      images: (map['images'] != null) ? List<String>.from(map['images']) : <String>[],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'status': status,
      'stock': stock,
      'brand': brand,
      'sizes': sizes,
      'colors': colors,
      'images': images,
    };
  }
}
