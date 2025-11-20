# Troubleshooting Guide

## Image Upload Errors

### Error: "Upload failed" or "No URL returned"

**Solution:**
1. Go to Cloudinary Dashboard: https://cloudinary.com/console
2. Navigate to: Settings → Upload → Upload Presets
3. Create new preset:
   - Name: `nfs_app_preset`
   - Signing Mode: **Unsigned** (IMPORTANT!)
   - Folder: Leave empty or set to `products`
4. Click Save

### Error: "Image file does not exist"

**Solution:**
- Make sure you selected valid image files
- Try selecting images again
- Check file permissions

### Error: "Failed to upload images"

**Possible causes:**
1. Upload preset not created
2. Upload preset is signed (must be unsigned)
3. Internet connection issue
4. Cloudinary credentials incorrect

**Verify credentials:**
- Cloud Name: `dwwypumxh`
- Upload Preset: `nfs_app_preset`

### Error: "Cloudinary configuration missing"

**Solution:**
Check `lib/config/cloudinary_config.dart` has:
```dart
static const String cloudName = 'dwwypumxh';
static const String uploadPreset = 'nfs_app_preset';
```

## Firebase Errors

### Error: "Permission denied"

**Solution:**
Deploy Firestore rules:
```bash
firebase deploy --only firestore:rules
```

### Error: "Collection not found"

**Solution:**
- Firebase is working correctly
- Collections are created automatically on first write

## Testing Steps

1. **Test Firebase:**
   - Open app
   - Login as admin
   - Check if dashboard loads

2. **Test Cloudinary:**
   - Go to Products page
   - Click "Add Product"
   - Add product details
   - Select images
   - Click "Create Product"
   - Check for success message

## Common Issues

### Images not displaying
- Check image URLs in Firestore
- URLs should start with: `https://res.cloudinary.com/dwwypumxh/`

### Upload takes too long
- Normal for first upload
- Subsequent uploads are faster
- Large images take longer

### App crashes on image select
- Check image picker permissions
- Try smaller images
- Restart app

## Need Help?

Check error message carefully - it will tell you:
- If upload preset is missing
- If credentials are wrong
- If internet connection failed
