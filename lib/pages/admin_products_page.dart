import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/admin_product.dart';
import '../services/admin_product_service.dart';
import '../widgets/admin_product_card.dart';
import '../widgets/add_edit_product_dialog.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final AdminProductService service = AdminProductService();
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'All Categories';
  String selectedBrand = 'All Brands';
  String selectedStatus = 'All Status';

  final List<String> categories = ['All Categories', 'Electronics', 'Accessories', 'Wearables'];
  final List<String> brands = ['All Brands', 'Apple', 'Samsung', 'Generic'];
  final List<String> statuses = ['All Status', 'Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _openAddEditDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 12),
          _buildFilterRow(),
          const SizedBox(height: 12),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text('Product Manager', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildDropdown(categories, selectedCategory, (v) => setState(() => selectedCategory = v))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown(brands, selectedBrand, (v) => setState(() => selectedBrand = v))),
          const SizedBox(width: 8),
          Expanded(child: _buildDropdown(statuses, selectedStatus, (v) => setState(() => selectedStatus = v))),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
          value: value,
          isExpanded: true,
          onChanged: (v) => onChanged(v ?? items.first),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<DatabaseEvent>(
      stream: service.productsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text('No products yet.'));
        }

        final Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        final List<AdminProduct> products = [];
        map.forEach((key, value) {
          final prod = AdminProduct.fromMap(key, value as Map<dynamic, dynamic>);
          products.add(prod);
        });

        final q = _searchController.text.toLowerCase();
        final filtered = products.where((p) {
          if (q.isNotEmpty && !('${p.name} ${p.category} ${p.brand}'.toLowerCase()).contains(q)) return false;
          if (selectedCategory != 'All Categories' && p.category != selectedCategory) return false;
          if (selectedBrand != 'All Brands' && p.brand != selectedBrand) return false;
          if (selectedStatus != 'All Status' && p.status != selectedStatus) return false;
          return true;
        }).toList();

        if (filtered.isEmpty) return const Center(child: Text('No products match.'));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final p = filtered[index];
            return AdminProductCard(
              product: p,
              onEdit: () => _openAddEditDialog(context, product: p),
              onDelete: () => _confirmDelete(p),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(AdminProduct p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete product?'),
        content: Text('Are you sure you want to delete "${p.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await service.deleteProduct(p.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openAddEditDialog(BuildContext ctx, {AdminProduct? product}) {
    showDialog(
      context: ctx,
      builder: (_) => AddEditProductDialog(
        product: product,
        onSave: (prod) async {
          if (prod.id.isEmpty) {
            await service.addProduct(prod);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added')),
              );
            }
          } else {
            await service.updateProduct(prod);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product updated')),
              );
            }
          }
        },
        uploadImage: (file) => service.uploadImage(file),
      ),
    );
  }
}
