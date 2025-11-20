import 'package:flutter/material.dart';
import 'products_page.dart' as products;
import '../test/connection_test.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  Widget _buildDashboard() {
    final stats = [
      {'title': 'Total Products', 'value': '12', 'icon': Icons.inventory_2, 'color': Colors.blue},
      {'title': 'Categories', 'value': '3', 'icon': Icons.category, 'color': Colors.green},
      {'title': 'Brands', 'value': '3', 'icon': Icons.store, 'color': Colors.purple},
      {'title': 'Total Orders', 'value': '0', 'icon': Icons.shopping_cart, 'color': Colors.orange},
      {'title': 'Customers', 'value': '1', 'icon': Icons.people, 'color': Colors.teal},
      {'title': 'Revenue', 'value': 'Rs. 0.00', 'icon': Icons.attach_money, 'color': Colors.green},
      {'title': 'Pending Orders', 'value': '0', 'icon': Icons.pending_actions, 'color': Colors.red},
      {'title': 'Total Reviews', 'value': '0', 'icon': Icons.rate_review, 'color': Colors.pink},
    ];

    final quickActions = [
      {'title': 'Manage Products', 'desc': 'Add, edit, or remove products', 'color': Colors.green.shade100},
      {'title': 'Process Orders', 'desc': 'View and update order status', 'color': Colors.blue.shade100},
      {'title': 'Moderate Reviews', 'desc': 'Approve or reject reviews', 'color': Colors.purple.shade100},
      {'title': 'Manage Collections', 'desc': 'Create product collections', 'color': Colors.orange.shade100},
    ];

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Welcome to your admin dashboard', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: stats[index]['color'] as Color,
                        child: Icon(stats[index]['icon'] as IconData, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(stats[index]['title'] as String, style: const TextStyle(fontSize: 14)),
                            Text(stats[index]['value'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...quickActions.map((action) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(action['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(action['desc'] as String, style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              );
            }),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.dashboard, color: Colors.black),
            SizedBox(width: 8),
            Text('NFS Admin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectionTestPage())),
          ),
          IconButton(icon: const Icon(Icons.notifications, color: Colors.black), onPressed: () {}),
          const CircleAvatar(backgroundColor: Colors.black, child: Text('A', style: TextStyle(color: Colors.white))),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(),
          const products.ProductsPage(),
          const Center(child: Text('Orders Page', style: TextStyle(fontSize: 24))),
          const Center(child: Text('Users Page', style: TextStyle(fontSize: 24))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        ],
      ),
    );
  }
}
