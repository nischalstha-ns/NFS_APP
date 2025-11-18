import 'package:flutter/foundation.dart';
import '../pages/product_details_page.dart';

class WishlistService extends ChangeNotifier {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<Product> _wishlistItems = [];

  List<Product> get wishlistItems => List.unmodifiable(_wishlistItems);

  bool isInWishlist(Product product) {
    return _wishlistItems.any((item) => item.id == product.id);
  }

  void addToWishlist(Product product) {
    if (!isInWishlist(product)) {
      _wishlistItems.add(product);
      notifyListeners();
    }
  }

  void removeFromWishlist(Product product) {
    _wishlistItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      removeFromWishlist(product);
    } else {
      addToWishlist(product);
    }
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }

  int get itemCount => _wishlistItems.length;
}