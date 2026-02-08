import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  List cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    final url = Uri.parse(
      'https://jewellery-backend-icja.onrender.com/api/cart/',
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('🟡 TOKEN: $token');

    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🟢 STATUS CODE: ${response.statusCode}');
      print('🟢 RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cartItems = data['cart']['items'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ ERROR: $e');
      setState(() => isLoading = false);
    }
  }

  int get totalAmount {
    int total = 0;
    for (final item in cartItems) {
      final product = item['product'];
      if (product != null) {
        total += (product['price'] as int) * (item['quantity'] as int);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6), // Elegant off-white background
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD4AF37), // Gold color
        ),
      )
          : cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40,
              vertical: isMobile ? 16 : 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shopping Cart',
                  style: TextStyle(
                    fontSize: isMobile ? 22 : 28,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cartItems.length} ${cartItems.length == 1 ? 'Item' : 'Items'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD4AF37),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cart Items
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: ListView.builder(
                  padding: EdgeInsets.all(isMobile ? 16 : 40),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final product = item['product'];

                    if (product == null) {
                      return const SizedBox();
                    }

                    return Container(
                      margin: EdgeInsets.only(
                        bottom: isMobile ? 16 : 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(
                                isMobile ? 12 : 20,
                              ),
                              child: Row(
                                children: [
                                  // Image with gold border
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFD4AF37)
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      child: Image.network(
                                        product['image']['url'],
                                        width: isMobile ? 90 : 140,
                                        height: isMobile ? 90 : 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: isMobile ? 12 : 24,
                                  ),

                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['title'],
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize:
                                            isMobile ? 16 : 20,
                                            fontWeight:
                                            FontWeight.w400,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: isMobile ? 8 : 12,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration:
                                              BoxDecoration(
                                                color: Colors
                                                    .grey.shade100,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(6),
                                              ),
                                              child: Text(
                                                '${product['gram']} g',
                                                style: TextStyle(
                                                  fontSize:
                                                  isMobile
                                                      ? 12
                                                      : 14,
                                                  color: Colors
                                                      .grey.shade700,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration:
                                              BoxDecoration(
                                                color: const Color(
                                                    0xFFD4AF37)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(6),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Qty: ',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(
                                                          0xFFD4AF37),
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item['quantity']}',
                                                    style:
                                                    const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(
                                                          0xFFD4AF37),
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: isMobile ? 8 : 12,
                                        ),
                                        Text(
                                          '₹${product['price']}',
                                          style: TextStyle(
                                            fontSize:
                                            isMobile ? 18 : 24,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: const Color(
                                                0xFFD4AF37),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Remove icon
                                  if (!isMobile)
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.grey.shade400,
                                        size: 24,
                                      ),
                                      onPressed: () {},
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Total Bar - Premium Design
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: isMobile ? 20 : 28,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹$totalAmount',
                        style: TextStyle(
                          fontSize: isMobile ? 26 : 32,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFD4AF37),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 28 : 48,
                        vertical: isMobile ? 16 : 20,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}