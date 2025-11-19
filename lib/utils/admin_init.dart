import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AdminInit {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initializeAdminUser() async {
    try {
      const adminEmail = 'nischal@gmail.com';
      
      // Check if admin user already exists
      final doc = await _firestore.collection('users').doc(adminEmail).get();
      
      if (!doc.exists) {
        // Create admin user document
        final adminUser = UserModel(
          uid: 'admin_uid', // This will be updated when user actually signs up
          email: adminEmail,
          role: 'admin',
          displayName: 'Admin User',
        );
        
        await _firestore.collection('users').doc(adminEmail).set(adminUser.toMap());
      } else {
        // Update existing user to admin if not already
        final userData = UserModel.fromMap(doc.data()!);
        if (userData.role != 'admin') {
          await _firestore.collection('users').doc(adminEmail).update({'role': 'admin'});
        }
      }
    } catch (e) {
      // Silent fail - admin will be created on first login
    }
  }
}