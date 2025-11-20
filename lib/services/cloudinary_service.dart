import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import '../config/cloudinary_config.dart';

class CloudinaryService {
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    CloudinaryConfig.cloudName,
    CloudinaryConfig.uploadPreset,
    cache: false,
  );

  static Future<String> uploadImage(File imageFile, String folder) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw 'Failed to upload image: $e';
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


}