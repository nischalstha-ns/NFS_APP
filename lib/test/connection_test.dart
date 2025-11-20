import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ConnectionTestPage extends StatefulWidget {
  const ConnectionTestPage({super.key});

  @override
  State<ConnectionTestPage> createState() => _ConnectionTestPageState();
}

class _ConnectionTestPageState extends State<ConnectionTestPage> {
  String _firebaseStatus = 'Testing...';
  String _cloudinaryStatus = 'Not tested';
  bool _isTestingCloudinary = false;

  @override
  void initState() {
    super.initState();
    _testFirebase();
  }

  Future<void> _testFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('test')
          .doc('connection_test')
          .set({'timestamp': DateTime.now().toIso8601String(), 'status': 'connected'});
      
      setState(() => _firebaseStatus = '✅ Firebase Connected');
    } catch (e) {
      setState(() => _firebaseStatus = '❌ Firebase Error: $e');
    }
  }

  Future<void> _testCloudinary() async {
    setState(() {
      _isTestingCloudinary = true;
      _cloudinaryStatus = 'Selecting image...';
    });

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) {
        setState(() {
          _cloudinaryStatus = '⚠️ No image selected';
          _isTestingCloudinary = false;
        });
        return;
      }

      setState(() => _cloudinaryStatus = 'Uploading...');

      final url = await CloudinaryService.uploadImage(File(image.path), 'test');
      
      setState(() {
        _cloudinaryStatus = '✅ Cloudinary Connected\n$url';
        _isTestingCloudinary = false;
      });
    } catch (e) {
      setState(() {
        _cloudinaryStatus = '❌ Error: $e';
        _isTestingCloudinary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Firebase', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_firebaseStatus),
            ),
            const SizedBox(height: 32),
            const Text('Cloudinary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_cloudinaryStatus),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isTestingCloudinary ? null : _testCloudinary,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
              child: _isTestingCloudinary
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Test Cloudinary'),
            ),
          ],
        ),
      ),
    );
  }
}
