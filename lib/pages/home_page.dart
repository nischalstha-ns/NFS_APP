import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: _bottomNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "NFS Store",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          const Icon(Icons.search, color: Colors.black),
          IconButton(
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bannerSection(),
            const SizedBox(height: 15),
            _sectionHeader("Popular Products"),
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _popularProduct(_createProduct("MacBook Pro", 1299, Icons.laptop_mac, "Premium laptop with M3 chip")),
                  _popularProduct(_createProduct("iPhone 15", 999, Icons.phone_iphone, "Latest iPhone with advanced features")),
                  _popularProduct(_createProduct("iPad Air", 599, Icons.tablet_mac, "Lightweight tablet for productivity")),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _sectionHeader("New Arrivals"),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.75,
              padding: const EdgeInsets.all(10),
              children: [
                _newProduct(_createProduct("AirPods Pro", 249, Icons.headphones, "Wireless earbuds with noise cancellation")),
                _newProduct(_createProduct("Apple Watch", 399, Icons.watch, "Smartwatch with health tracking")),
                _newProduct(_createProduct("Magic Mouse", 79, Icons.mouse, "Wireless mouse with multi-touch")),
                _newProduct(_createProduct("Magic Keyboard", 129, Icons.keyboard, "Wireless keyboard with backlight")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Product _createProduct(String name, double price, IconData icon, String description) {
    return Product(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      price: price,
      description: description,
      icon: icon,
      colors: [Colors.black, Colors.white, Colors.grey],
      category: 'Electronics',
    );
  }

  Widget _bannerSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome ${_authService.currentUser?.email?.split('@')[0] ?? 'User'}!",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Discover Amazing\nProducts",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text("Shop Now",
                        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.shopping_bag, size: 80, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            "See All",
            style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _popularProduct(Product product) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1), 
              blurRadius: 8, 
              offset: const Offset(0, 4)),
        ],
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(product.icon, size: 80, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 10),
            Text(product.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("\$${product.price.toStringAsFixed(0)}",
                style: const TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _newProduct(Product product) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(product.icon, size: 60, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                ),
                const Icon(Icons.favorite_border, color: Colors.deepPurple, size: 18),
              ],
            ),
            const SizedBox(height: 4),
            Text("\$${product.price.toStringAsFixed(0)}",
                style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: "Wishlist"),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}