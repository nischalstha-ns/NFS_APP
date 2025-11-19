import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isCurrentUserAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    return await isUserAdmin(user.email!);
  }

  Future<bool> isUserAdmin(String email) async {
    try {
      final doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        final userData = UserModel.fromMap(doc.data()!);
        return userData.isAdmin;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> createAdminUser(String email) async {
    final user = _auth.currentUser;
    if (user != null && user.email == email) {
      final userData = UserModel(
        uid: user.uid,
        email: email,
        role: 'admin',
        displayName: user.displayName,
      );
      
      await _firestore.collection('users').doc(email).set(userData.toMap());
    }
  }
}