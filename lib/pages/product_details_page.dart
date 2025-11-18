import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final IconData icon;
  final List<Color> colors;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
    required this.colors,
    required this.category,
  });
}

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;
  int selectedColorIndex = 0;
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () => _showShareDialog(),
            icon: const Icon(Icons.share, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productGallery(),
            const SizedBox(height: 15),
            _shippingBadge(),
            const SizedBox(height: 10),
            _productInfo(),
            const SizedBox(height: 20),
            _priceSection(),
            const SizedBox(height: 20),
            _colorSelector(),
            const SizedBox(height: 25),
            _purchaseInfo(),
            const SizedBox(height: 25),
            _couponBox(),
            const SizedBox(height: 20),
            _deliveryInfo(),
          ],
        ),
      ),
    );
  }

  Widget _productGallery() {
    return Row(
      children: [
        Column(
          children: [
            _thumbIcon(widget.product.icon, true),
            _thumbIcon(widget.product.icon, false),
            _thumbIcon(widget.product.icon, false),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Icon(
                widget.product.icon,
                size: 120,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _thumbIcon(IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple.withValues(alpha: 0.1) : Colors.grey.shade200,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.deepPurple, width: 2) : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.deepPurple : Colors.black54,
        size: 20,
      ),
    );
  }

  Widget _shippingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "✓ Free Shipping",
        style: TextStyle(
          color: Colors.green,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _productInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description,
          style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
        ),
      ],
    );
  }

  Widget _priceSection() {
    return Row(
      children: [
        Text(
          "\$${widget.product.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 28,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "\$${(widget.product.price * 1.2).toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }

  Widget _colorSelector() {
    if (widget.product.colors.isEmpty) return const SizedBox.shrink();
    
    return Row(
      children: [
        const Text(
          "Color",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 15),
        Row(
          children: List.generate(widget.product.colors.length, (i) {
            return GestureDetector(
              onTap: () => setState(() => selectedColorIndex = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedColorIndex == i ? Colors.deepPurple : Colors.grey,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: widget.product.colors[i],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _purchaseInfo() {
    return Row(
      children: [
        Stack(
          children: [
            _userAvatar(Colors.blue, 0),
            Positioned(left: 20, child: _userAvatar(Colors.green, 1)),
            Positioned(left: 40, child: _userAvatar(Colors.orange, 2)),
            Positioned(left: 60, child: _userAvatar(Colors.red, 3)),
          ],
        ),
        const SizedBox(width: 80),
        const Text(
          "2,847+ Already Purchased",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _userAvatar(Color color, int index) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: color,
      child: Text(
        String.fromCharCode(65 + index),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _couponBox() {
    return TextField(
      controller: _couponController,
      decoration: InputDecoration(
        labelText: "Have a coupon? Enter here",
        labelStyle: const TextStyle(fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        suffixIcon: IconButton(
          onPressed: () => _applyCoupon(),
          icon: const Icon(Icons.local_offer, color: Colors.deepPurple),
        ),
      ),
    );
  }

  Widget _deliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.local_shipping, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text("Express Delivery", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          const Text("Available", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Row(
            children: [
              _qtyBtn(Icons.remove, () {
                if (quantity > 1) setState(() => quantity--);
              }),
              const SizedBox(width: 15),
              Text(
                quantity.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 15),
              _qtyBtn(Icons.add, () => setState(() => quantity++)),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => _buyNow(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "Buy Now - \$${(widget.product.price * quantity).toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Icon(icon, size: 18, color: Colors.deepPurple),
      ),
    );
  }

  void _buyNow() {
    final total = widget.product.price * quantity;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Purchase Confirmation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product: ${widget.product.name}"),
            Text("Quantity: $quantity"),
            Text("Total: \$${total.toStringAsFixed(2)}"),
            if (_couponController.text.isNotEmpty)
              Text("Coupon: ${_couponController.text}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processPurchase();
            },
            child: const Text("Confirm Purchase"),
          ),
        ],
      ),
    );
  }

  void _processPurchase() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Purchase successful! ${widget.product.name} x$quantity"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _applyCoupon() {
    if (_couponController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Coupon applied successfully!")),
      );
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Product"),
        content: Text("Share ${widget.product.name} with friends!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}