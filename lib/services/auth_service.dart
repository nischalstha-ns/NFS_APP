import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _ensureUserDocument(result.user!);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _createUserDocument(result.user!);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _createUserDocument(User user) async {
    final userData = UserModel(
      uid: user.uid,
      email: user.email!,
      role: user.email == 'nischal@gmail.com' ? 'admin' : 'user',
      displayName: user.displayName,
    );
    
    await _firestore.collection('users').doc(user.email).set(userData.toMap());
  }

  Future<void> _ensureUserDocument(User user) async {
    final doc = await _firestore.collection('users').doc(user.email).get();
    if (!doc.exists) {
      await _createUserDocument(user);
    }
  }
}