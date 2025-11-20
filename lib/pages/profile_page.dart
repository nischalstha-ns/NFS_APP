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
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _showHeaderAvatar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
      _showHeaderAvatar = _scrollOffset > 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(userName),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(userName),
                _buildWaveSeparator(),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildMyOrders(),
                      const SizedBox(height: 24),
                      _buildProfileOptions(),
                      const SizedBox(height: 32),
                      _buildLogoutButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(String userName) {
    return SliverAppBar(
      pinned: true,
      elevation: _showHeaderAvatar ? 4 : 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: const Text('Profile', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
      actions: [
        AnimatedOpacity(
          opacity: _showHeaderAvatar ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.pink,
              child: Text(userName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(String userName) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 56,
                backgroundColor: Colors.pink,
                child: Text(userName[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                  child: const Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          const Text('NFS Store Customer', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWaveSeparator() {
    return CustomPaint(
      size: const Size(double.infinity, 60),
      painter: WavePainter(),
    );
  }

  Widget _buildMyOrders() {
    return ListenableBuilder(
      listenable: Listenable.merge([_cartService, _wishlistService]),
      builder: (context, child) {
        final orders = [
          {'label': 'Pending\nPayment', 'icon': Icons.payment, 'colors': [const Color(0xFF40C9FF), const Color(0xFF1890FF)], 'count': 0},
          {'label': 'Delivered', 'icon': Icons.local_shipping, 'colors': [const Color(0xFFFFD700), const Color(0xFFFFA500)], 'count': 0},
          {'label': 'Processing', 'icon': Icons.inventory, 'colors': [const Color(0xFFFF8A8A), const Color(0xFFFF5252)], 'count': 0},
          {'label': 'Cancelled', 'icon': Icons.cancel, 'colors': [const Color(0xFF56F26D), const Color(0xFF00C853)], 'count': 0},
          {'label': 'Wishlist', 'icon': Icons.favorite, 'colors': [const Color(0xFFFF80AB), const Color(0xFFF50057)], 'count': _wishlistService.itemCount},
          {'label': 'Cart', 'icon': Icons.shopping_cart, 'colors': [const Color(0xFFB388FF), const Color(0xFF7C4DFF)], 'count': _cartService.itemCount},
        ];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: order['colors'] as List<Color>,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(order['icon'] as IconData, color: Colors.white, size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order['label'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        if ((order['count'] as int) > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                              child: Text(
                                '${order['count']}',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          FutureBuilder<bool>(
            future: AdminService().isCurrentUserAdmin(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return _buildOption(Icons.admin_panel_settings, 'Admin Panel', Colors.red, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminGuard()));
                });
              }
              return const SizedBox.shrink();
            },
          ),
          _buildOption(Icons.edit, 'Edit Profile', const Color(0xFF6366F1), () => _showEditProfile()),
          _buildOption(Icons.location_on, 'Shipping Address', const Color(0xFF6366F1), () => _showShippingAddress()),
          _buildOption(Icons.payment, 'Payment Methods', const Color(0xFF6366F1), () => _showPaymentMethods()),
          _buildOption(Icons.notifications, 'Notifications', const Color(0xFF6366F1), () => _showNotifications()),
          _buildOption(Icons.help, 'Help & Support', const Color(0xFF6366F1), () => _showHelp(), isLast: true),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, Color color, VoidCallback onTap, {bool isLast = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _logout,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout, color: Colors.grey, size: 24),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
          ],
        ),
      ),
    );
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



  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              await _authService.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFD20063), Color(0xFFE81F76)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.8, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.1, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}