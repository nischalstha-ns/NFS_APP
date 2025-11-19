import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/admin_product.dart';

class AdminProductService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child('products');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<DatabaseEvent> productsStream() => _db.onValue;

  Future<String> uploadImage(File file, {String? pathPrefix}) async {
    final String id = const Uuid().v4();
    final String path = '${pathPrefix ?? 'product_images'}/$id.jpg';
    final ref = _storage.ref().child(path);
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
  }

  Future<void> addProduct(AdminProduct p) async {
    final ref = _db.push();
    await ref.set(p.toMap());
  }

  Future<void> updateProduct(AdminProduct p) async {
    await _db.child(p.id).set(p.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.child(id).remove();
  }
}
