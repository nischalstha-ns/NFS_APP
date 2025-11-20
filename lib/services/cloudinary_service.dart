import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import '../config/cloudinary_config.dart';

class CloudinaryService {
  static CloudinaryPublic? _cloudinary;

  static CloudinaryPublic _getCloudinary() {
    _cloudinary ??= CloudinaryPublic(
      CloudinaryConfig.cloudName,
      CloudinaryConfig.uploadPreset,
      cache: false,
    );
    return _cloudinary!;
  }

  static Future<String> uploadImage(File imageFile, String folder) async {
    try {
      if (!await imageFile.exists()) {
        throw 'Image file does not exist';
      }

      final cloudinary = _getCloudinary();
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      
      if (response.secureUrl.isEmpty) {
        throw 'Upload failed: No URL returned';
      }
      
      return response.secureUrl;
    } catch (e) {
      throw 'Upload failed: $e';
    }
  }

  static Future<List<String>> uploadMultipleImages(List<File> imageFiles, String folder) async {
    try {
      final List<String> urls = [];
      for (var file in imageFiles) {
        final url = await uploadImage(file, folder);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw 'Failed to upload images: $e';
    }
  }

  static Future<List<String>> uploadMultipleXFiles(List<XFile> xFiles, String folder) async {
    try {
      final List<String> urls = [];
      for (var xFile in xFiles) {
        final bytes = await xFile.readAsBytes();
        final cloudinary = _getCloudinary();
        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: xFile.name,
            folder: folder,
            resourceType: CloudinaryResourceType.Image,
          ),
        );
        
        if (response.secureUrl.isEmpty) {
          throw 'Upload failed: No URL returned';
        }
        
        urls.add(response.secureUrl);
      }
      return urls;
    } catch (e) {
      throw 'Failed to upload images: $e';
    }
  }
}