# Cloudinary Setup Guide

## Configuration
The app is configured to use Cloudinary for image storage with the following credentials:
- Cloud Name: `dwwypumxh`
- API Key: `479296475871715`
- API Secret: `bL5aR2vRfHPd2j_rGVc8LCxqEjQ`

## Setup Steps

### 1. Create Upload Preset in Cloudinary
1. Go to Cloudinary Dashboard: https://cloudinary.com/console
2. Navigate to Settings → Upload
3. Scroll to "Upload presets"
4. Click "Add upload preset"
5. Set preset name: `nfs_app_preset`
6. Set Signing Mode: `Unsigned`
7. Set Folder: Leave empty or set default folder
8. Save the preset

### 2. Configure Folders
The app uses the following folder structure in Cloudinary:
- `products/{productId}/` - Product images
- `categories/` - Category images
- `users/{userId}/` - User profile images

## Usage

### Upload Product Images
```dart
import 'package:image_picker/image_picker.dart';
import 'services/product_service.dart';

final picker = ImagePicker();
final images = await picker.pickMultiImage();
final imageFiles = images.map((e) => File(e.path)).toList();

await ProductService().addProduct(
  name: 'Product Name',
  description: 'Description',
  price: 99.99,
  category: 'Category',
  brand: 'Brand',
  imageFiles: imageFiles,
  stock: 10,
);
```

### Image URLs
All uploaded images return secure HTTPS URLs that are stored in Firestore.

## Database Structure
```
Firestore:
└── products (collection)
    └── {productId} (document)
        ├── id: "uuid"
        ├── name: "Product Name"
        ├── description: "Description"
        ├── price: 99.99
        ├── category: "Category"
        ├── brand: "Brand"
        ├── images: ["https://res.cloudinary.com/..."]
        ├── stock: 10
        └── createdAt: "2024-01-01T00:00:00.000Z"
```

## Features
✅ Multiple image upload support
✅ Automatic image optimization by Cloudinary
✅ Secure HTTPS URLs
✅ Image deletion support
✅ Organized folder structure
✅ Integration with Firebase Firestore