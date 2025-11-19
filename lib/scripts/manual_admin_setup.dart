import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  
  await firestore.collection('users').doc('nischal@gmail.com').set({
    'uid': 'admin_uid',
    'email': 'nischal@gmail.com',
    'role': 'admin',
    'displayName': 'Admin User',
  });
}