import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../services/admin_service.dart';
import '../admin/admin_guard.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF6C63FF);
    final Color secondary = const Color(0xFF9C88FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _header(primary, secondary),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "My Orders",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _orderGrid(),
                  const SizedBox(height: 30),
                  _profileOptions(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _header(Color primary, Color secondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [secondary, primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text(
            "Profile",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _authService.currentUser?.email?.split('@')[0] ?? 'User',
            style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "NFS Store Customer",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _orderGrid() {
    return ListenableBuilder(
      listenable: Listenable.merge([_cartService, _wishlistService]),
      builder: (context, child) {
        List<Map<String, dynamic>> items = [
          {"icon": Icons.payment, "label": "Pending Payment", "color": Colors.blue, "count": 0},
          {"icon": Icons.check_circle, "label": "Delivered", "color": Colors.green, "count": 0},
          {"icon": Icons.refresh, "label": "Processing", "color": Colors.orange, "count": 0},
          {"icon": Icons.cancel, "label": "Cancelled", "color": Colors.red, "count": 0},
          {"icon": Icons.favorite, "label": "Wishlist", "color": Colors.pink, "count": _wishlistService.itemCount, "onTap": () => _navigateToWishlist()},
          {"icon": Icons.shopping_cart, "label": "Cart Items", "color": Colors.purple, "count": _cartService.itemCount, "onTap": () => _navigateToCart()},
        ];

        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: items[i]["onTap"],
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: items[i]["color"].withValues(alpha: 0.1),
                        child: Icon(items[i]["icon"], color: items[i]["color"], size: 28),
                      ),
                      if (items[i]["count"] > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                            child: Text(
                              '${items[i]["count"]}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    items[i]["label"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _profileOptions() {
    return Column(
      children: [
        FutureBuilder<bool>(
          future: AdminService().isCurrentUserAdmin(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return _optionTile(
                Icons.admin_panel_settings,
                "Admin Panel",
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminGuard())),
                color: Colors.red,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        _optionTile(Icons.edit, "Edit Profile", () => _showEditProfile()),
        _optionTile(Icons.location_on, "Shipping Address", () => _showShippingAddress()),
        _optionTile(Icons.payment, "Payment Methods", () => _showPaymentMethods()),
        _optionTile(Icons.notifications, "Notifications", () => _showNotifications()),
        _optionTile(Icons.help, "Help & Support", () => _showHelp()),
        _optionTile(Icons.info, "About", () => _showAbout()),
      ],
    );
  }

  Widget _optionTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: color ?? const Color(0xFF6C63FF)),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }

  Widget _logoutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: _logout,
        child: const Text(
          "⏻ Logout",
          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _navigateToWishlist() {
    // Navigation handled by main navigation
  }

  void _navigateToCart() {
    // Navigation handled by main navigation
  }

  void _showEditProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Profile"),
        content: const Text("Profile editing feature coming soon!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showShippingAddress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Shipping Address"),
        content: const Text("Manage your shipping addresses here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Payment Methods"),
        content: const Text("Manage your payment methods here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Notifications"),
        content: const Text("Notification settings coming soon!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Help & Support"),
        content: const Text("Contact us at support@nfsstore.com for assistance."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("About NFS Store"),
        content: const Text("NFS Store v1.0.0\nYour trusted shopping companion."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}