import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import 'cloudinary_service.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String category,
    required String brand,
    required List<File> imageFiles,
    required int stock,
  }) async {
    try {
      final productId = _uuid.v4();
      
      final imageUrls = await CloudinaryService.uploadMultipleImages(
        imageFiles,
        'products/$productId',
      );

      final product = ProductModel(
        id: productId,
        name: name,
        description: description,
        price: price,
        category: category,
        brand: brand,
        images: imageUrls,
        stock: stock,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('products').doc(productId).set(product.toMap());
    } catch (e) {
      throw 'Failed to add product: $e';
    }
  }

  Future<void> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required String category,
    required String brand,
    List<File>? newImageFiles,
    List<String>? existingImages,
    required int stock,
  }) async {
    try {
      List<String> imageUrls = existingImages ?? [];

      if (newImageFiles != null && newImageFiles.isNotEmpty) {
        final newUrls = await CloudinaryService.uploadMultipleImages(
          newImageFiles,
          'products/$productId',
        );
        imageUrls.addAll(newUrls);
      }

      await _firestore.collection('products').doc(productId).update({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'brand': brand,
        'images': imageUrls,
        'stock': stock,
      });
    } catch (e) {
      throw 'Failed to update product: $e';
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw 'Failed to delete product: $e';
    }
  }

  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList(),
    );
  }

  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to get product: $e';
    }
  }
}