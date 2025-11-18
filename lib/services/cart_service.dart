import 'package:flutter/foundation.dart';
import '../pages/product_details_page.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _cartItems = [];
  String _appliedCoupon = '';
  double _discountPercentage = 0.0;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  String get appliedCoupon => _appliedCoupon;
  double get discountPercentage => _discountPercentage;

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _appliedCoupon = '';
    _discountPercentage = 0.0;
    notifyListeners();
  }

  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * (_discountPercentage / 100);

  double get total => subtotal - discountAmount;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  bool applyCoupon(String couponCode) {
    final validCoupons = {
      'SAVE10': 10.0,
      'SAVE20': 20.0,
      'WELCOME': 15.0,
    };

    if (validCoupons.containsKey(couponCode.toUpperCase())) {
      _appliedCoupon = couponCode.toUpperCase();
      _discountPercentage = validCoupons[couponCode.toUpperCase()]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = '';
    _discountPercentage = 0.0;
    notifyListeners();
  }
}