import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import '../services/cloudinary_service.dart';

class ProductFormPage extends StatefulWidget {
  final String? productId;

  const ProductFormPage({super.key, this.productId});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  String _status = 'Active';
  List<String> _selectedSizes = [];
  List<String> _selectedColors = [];
  List<XFile> _newImages = [];
  List<String> _existingImages = [];
  bool _isLoading = false;

  final List<String> _predefinedSizes = ['M', 'L', 'XL', '2XL', '3XL', '4XL', '5XL', '6XL', '16', '18', '20', '22', '24', '26', '28', '30', '32', '34', '36', '38'];
  final List<String> _predefinedColors = ['Red', 'Blue', 'Green', 'Yellow', 'Black', 'White', 'Gray', 'Pink', 'Purple', 'Orange', 'Brown', 'Navy', 'Beige', 'Maroon'];

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    final doc = await FirebaseFirestore.instance.collection('products').doc(widget.productId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _categoryController.text = data['category'] ?? '';
        _brandController.text = data['brand'] ?? '';
        _priceController.text = data['price']?.toString() ?? '';
        _stockController.text = data['stock']?.toString() ?? '';
        _status = data['status'] ?? 'Active';
        _selectedSizes = List<String>.from(data['sizes'] ?? []);
        _selectedColors = List<String>.from(data['colors'] ?? []);
        _existingImages = List<String>.from(data['images'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    const SizedBox(height: 24),
                    _buildTextField('Product Name', _nameController, required: true),
                    const SizedBox(height: 16),
                    _buildTextField('Description', _descriptionController, maxLines: 3),
                    const SizedBox(height: 16),
                    _buildTextField('Category', _categoryController, required: true),
                    const SizedBox(height: 16),
                    _buildTextField('Brand', _brandController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Price', _priceController, keyboardType: TextInputType.number, required: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField('Stock', _stockController, keyboardType: TextInputType.number)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStatusDropdown(),
                    const SizedBox(height: 24),
                    _buildSizesSection(),
                    const SizedBox(height: 24),
                    _buildColorsSection(),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Product Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate, size: 20),
              label: const Text('Add Images'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_existingImages.isNotEmpty || _newImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _existingImages.length + _newImages.length,
              itemBuilder: (context, index) {
                if (index < _existingImages.length) {
                  return _buildImagePreview(_existingImages[index], isUrl: true);
                } else {
                  final fileIndex = index - _existingImages.length;
                  return _buildImagePreview(_newImages[fileIndex].path, isUrl: false, xFile: _newImages[fileIndex]);
                }
              },
            ),
          )
        else
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('No images selected', style: TextStyle(color: Colors.grey[600])),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePreview(String path, {required bool isUrl, XFile? xFile}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey[200],
              child: isUrl
                  ? Image.network(
                      path,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                  : xFile != null
                      ? FutureBuilder<Uint8List>(
                          future: xFile.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.memory(
                                snapshot.data!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        )
                      : const Icon(Icons.error),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isUrl) {
                    _existingImages.remove(path);
                  } else {
                    _newImages.removeWhere((f) => f.path == path);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType, bool required = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: required ? (v) => v!.isEmpty ? 'Required' : null : null,
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: ['Active', 'Inactive', 'Draft'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (v) => setState(() => _status = v!),
    );
  }

  Widget _buildSizesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sizes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_selectedSizes.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedSizes.map((size) => Chip(
              label: Text(size),
              onDeleted: () => setState(() => _selectedSizes.remove(size)),
              backgroundColor: Colors.blue[100],
            )).toList(),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _predefinedSizes.map((size) {
            final isSelected = _selectedSizes.contains(size);
            return ChoiceChip(
              label: Text(size),
              selected: isSelected,
              selectedColor: Colors.blue,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSizes.add(size);
                  } else {
                    _selectedSizes.remove(size);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Colors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_selectedColors.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedColors.map((color) => Chip(
              label: Text(color),
              onDeleted: () => setState(() => _selectedColors.remove(color)),
              backgroundColor: Colors.purple[100],
            )).toList(),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _predefinedColors.map((color) {
            final isSelected = _selectedColors.contains(color);
            return ChoiceChip(
              label: Text(color),
              selected: isSelected,
              selectedColor: Colors.purple,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedColors.add(color);
                  } else {
                    _selectedColors.remove(color);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(widget.productId == null ? 'Create Product' : 'Update Product'),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _newImages.addAll(images);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.productId == null && _newImages.isEmpty && _existingImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<String> allImageUrls = List.from(_existingImages);

      if (_newImages.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading images...'), duration: Duration(seconds: 2)),
          );
        }
        
        try {
          final uploadedUrls = await CloudinaryService.uploadMultipleXFiles(_newImages, 'products');
          
          if (uploadedUrls.isEmpty) {
            throw 'No images were uploaded';
          }
          
          allImageUrls.addAll(uploadedUrls);
        } catch (uploadError) {
          throw 'Image upload failed: $uploadError\n\nMake sure:\n1. Upload preset "nfs_app_preset" exists in Cloudinary\n2. Preset is set to "Unsigned"\n3. Internet connection is stable';
        }
      }

      final productData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _categoryController.text.trim(),
        'brand': _brandController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text.isEmpty ? '0' : _stockController.text),
        'status': _status,
        'sizes': _selectedSizes,
        'colors': _selectedColors,
        'images': allImageUrls,
      };

      if (widget.productId == null) {
        await FirebaseFirestore.instance.collection('products').add(productData);
      } else {
        await FirebaseFirestore.instance.collection('products').doc(widget.productId).update(productData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.productId == null ? 'Product created successfully!' : 'Product updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
