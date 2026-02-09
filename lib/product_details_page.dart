import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jewellery/web_footer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  Future<void> addToCart(BuildContext context) async {
    final url = Uri.parse(
      'https://jewellery-backend-icja.onrender.com/api/cart/add',
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('🟡 TOKEN FROM STORAGE: $token');
    print('🟡 PRODUCT ID: ${product['_id']}');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ FIX
        },
        body: jsonEncode({
          'productId': product['_id'],
          'quantity': 1,
        }),
      );

      print('🟢 STATUS CODE: ${response.statusCode}');
      print('🟢 RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ ERROR: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> addToWishlist(BuildContext context) async {
    final url = Uri.parse(
      'https://jewellery-backend-icja.onrender.com/api/wishlist',
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('🟡 TOKEN FROM STORAGE: $token');
    print('🟡 PRODUCT ID: ${product['_id']}');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ REQUIRED
        },
        body: jsonEncode({
          'productId': product['_id'], // ✅ BODY AS PER API
        }),
      );

      print('🟢 STATUS CODE: ${response.statusCode}');
      print('🟢 RESPONSE BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Wishlist failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ ERROR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

      @override
  Widget build(BuildContext context) {
    final imageUrl = product['image']?['url'] ??
        'https://via.placeholder.com/150';
    final title = product['title'] ?? 'No Title';
    final price = product['price'] ?? 0;
    final category = product['category']?['name'] ?? 'No Category';
    final subcategory = product['subcategory']?['name'] ?? 'No Subcategory';
    final gram = product['gram'] ?? 0;
    final description = product['description'] ?? 'No Description';
    final quantity = product['quantity'] ?? 0;
    final isAvailable = product['isAvailable'] ?? false;

    // Screen size check pannitu responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isMobile
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                // Details
                _buildProductDetails(
                  context,
                  title,
                  price,
                  category,
                  subcategory,
                  gram,
                  quantity,
                  isAvailable,
                  description,
                ),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 500,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Details
                Expanded(
                  flex: 1,
                  child: _buildProductDetails(
                    context,
                    title,
                    price,
                    category,
                    subcategory,
                    gram,
                    quantity,
                    isAvailable,
                    description,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const WebFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(
      BuildContext context,
      String title,
      int price,
      String category,
      String subcategory,
      int gram,
      int quantity,
      bool isAvailable,
      String description,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),

        // Price
        Text(
          '₹$price',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 12),

        // Category & Subcategory
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subcategory,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            Text(
              'Gram: $gram g',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              'Qty: $quantity',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            Text(
              isAvailable ? 'Available' : 'Out of Stock',
              style: TextStyle(
                fontSize: 16,
                color: isAvailable ? Colors.green : Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Description
        const Text(
          'DESCRIPTION',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Crafted in hallmarked 22K gold, this exquisite jewellery piece blends timeless elegance with modern finesse. '
              'Its fine detailing and radiant finish make it a perfect companion for weddings, festive occasions, and everyday luxury. '
              'Designed for comfort and durability, it adds a graceful touch to every look while celebrating the beauty of pure gold.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  addToCart(context);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('ADD TO CART'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56), // height increase
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // box shape
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                  onPressed: () {
                    addToWishlist(context);
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text('WISHLIST'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  minimumSize: const Size.fromHeight(56), // height increase
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // box shape
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}