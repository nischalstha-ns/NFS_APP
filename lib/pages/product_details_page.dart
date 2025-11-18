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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => _showShareDialog(),
              icon: const Icon(Icons.share_rounded, color: Colors.black87, size: 20),
            ),
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
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _thumbIcon(widget.product.icon, true),
                _thumbIcon(widget.product.icon, false),
                _thumbIcon(widget.product.icon, false),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6C63FF).withValues(alpha: 0.1),
                    const Color(0xFF9C88FF).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.product.icon,
                    size: 100,
                    color: const Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbIcon(IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6C63FF).withValues(alpha: 0.15) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: const Color(0xFF6C63FF), width: 2) : null,
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFF6C63FF) : Colors.black54,
        size: 18,
      ),
    );
  }

  Widget _shippingBadge() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_shipping_rounded, color: Colors.green, size: 16),
              SizedBox(width: 6),
              Text(
                "Free Shipping",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text(
                "4.8",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "\$${widget.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-20%",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "\$${(widget.product.price * 1.2).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _qtyBtn(Icons.remove, () {
                    if (quantity > 1) setState(() => quantity--);
                  }),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _qtyBtn(Icons.add, () => setState(() => quantity++)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _buyNow(),
                    child: Center(
                      child: Text(
                        "Buy Now • \$${(widget.product.price * quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.white, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 18, color: const Color(0xFF6C63FF)),
          ),
        ),
      ),
    );
  }

  void _buyNow() {
    final total = widget.product.price * quantity;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Purchase Confirmation", style: TextStyle(fontWeight: FontWeight.w600)),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _processPurchase();
            },
            child: const Text("Confirm Purchase", style: TextStyle(color: Colors.white)),
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _applyCoupon() {
    if (_couponController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Coupon applied successfully!"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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