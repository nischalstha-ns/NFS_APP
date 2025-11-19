import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import 'admin_dashboard.dart';

class AdminGuard extends StatelessWidget {
  const AdminGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AdminService().isCurrentUserAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return Scaffold(
            appBar: AppBar(title: const Text('Access Denied')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Access Denied',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('You do not have admin privileges.'),
                ],
              ),
            ),
          );
        }
        
        return const AdminDashboard();
      },
    );
  }
}