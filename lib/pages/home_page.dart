import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jewellery/product_details_page.dart';
import 'package:jewellery/web_footer.dart';
import '../layout/main_layout.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<dynamic> _products = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    const url = 'https://jewellery-backend-icja.onrender.com/api/products/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            _products = data;
            _isLoading = false;
          });
        } else {
          print('Unexpected API response: $data');
          setState(() => _isLoading = false);
        }
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {


    final isMobile = MediaQuery.of(context).size.width < 768;

    final List<String> adImages = [
      'assets/advertisement/img_2.png',
      'assets/advertisement/img_2.png',
      'assets/advertisement/img_11.png',
      'assets/advertisement/img_12.png',
      'assets/advertisement/img_3.png',
      'assets/advertisement/img_4.png',

    ];
    final List<String> bottomImages = [
      'assets/advertisement/img_7.png',
      'assets/advertisement/img_2.png',
      'assets/advertisement/img_8.png',
      'assets/advertisement/img_9.png',
    ];

    final crossAxisCount = isMobile ? 2 : 4;
    final maxItems = crossAxisCount * 2;
    final double carouselHeight = isMobile ? 220 : 450; // smaller height on mobile
    return Scaffold(
      backgroundColor: Colors.white,
      body: MainLayout(
        isMobile: isMobile,
        body: SingleChildScrollView(
          child: Column(
            children: [
          CarouselSlider(
          options: CarouselOptions(
          height: carouselHeight,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            autoPlayInterval: const Duration(seconds: 3),
          ),
                items: adImages.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: isMobile ? BoxFit.cover : BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // ensures single row scrolls on small screens
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _featureItem(
                        icon: Icons.diamond,
                        title: 'Premium Diamonds',
                        description:
                        'Our diamonds are certified and sourced from trusted suppliers. Every stone is hand-selected for clarity, cut, and brilliance to ensure exceptional quality for your special moments.',
                      ),
                      _featureItem(
                        icon: Icons.workspace_premium,
                        title: 'Gold Jewelry',
                        description:
                        'We offer 24k pure gold jewelry crafted by master artisans. Each piece is designed to capture elegance and luxury, perfect for gifts and celebrations.',
                      ),
                      _featureItem(
                        icon: Icons.favorite,
                        title: 'Gemstones',
                        description:
                        'Rare and precious gemstones carefully curated for their color and clarity. Our collection includes rubies, emeralds, sapphires, and more, each telling a unique story.',
                      ),
                      _featureItem(
                        icon: Icons.local_shipping,
                        title: 'Fast Delivery',
                        description:
                        'Safe and reliable shipping to your doorstep. Track your order in real time, ensuring your precious jewelry arrives securely and on time.',
                      ),
                    ],
                  ),
                ),
              ),

              // Centered short divider
              Center(
                child: Container(
                  width: 500, // your desired width
                  child: const Divider(
                    height: 30, // space around divider
                    color: Colors.grey, // divider color
                    thickness: 2, // thickness of the line
                  ),
                ),
              ),
              // Products Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 30,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Gold Rings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'All our designs are curated by the top gold smith',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _products.isEmpty
                        ? const Center(child: Text('No products found'))
                        : GridView.builder(
              shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 50,
                  childAspectRatio: 0.85,
                ),
                      itemCount: _products.length, // show all products
                itemBuilder: (context, index) {
                  final product = _products[index];
                        final imageUrl = product['image']?['url'] ??
                            'https://via.placeholder.com/150';
                        final title = product['title'] ?? '';
                        final price = product['price'] ?? 0;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image with overlay text
                                Expanded(
                                  child: Stack(
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(8),
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Gradient overlay (optional - for better text visibility)
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.7),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '₹$price',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30), // spacing from products

                    const Text(
                      'DIAMOND',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30), // spacing from products

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: SizedBox(
                        height: 320, // adjust based on image height
                        child: GridView.count(
                          crossAxisCount: 2, // 2 images per row
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          physics: const NeverScrollableScrollPhysics(), // disables scroll
                          children: bottomImages.map((img) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                img,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const WebFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 Jewelry Features Row

// 🔹 Feature item widget
Widget _featureItem({required IconData icon, required String title, required String description}) {
return Container(
  width: 150,
margin: const EdgeInsets.symmetric(horizontal: 12),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
icon,
size: 50,
color: const Color(0xFFD4AF37), // gold color
),
const SizedBox(height: 12),
Text(
title,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 8),
Text(
description,
style: const TextStyle(
fontSize: 12,
color: Colors.grey,
),
textAlign: TextAlign.center,
),
],
),
);
}