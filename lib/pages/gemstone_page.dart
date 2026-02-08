import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jewellery/web_footer.dart';
import '../layout/main_layout.dart';

class GemstonePage extends StatelessWidget {
  const GemstonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    // List of asset images for the slider
    final List<String> adImages = [
      'assets/advertisement/Banner1.png',
      'assets/advertisement/Banner2.png',
      'assets/advertisement/Banner3.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: MainLayout(
        isMobile: isMobile,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Slider at the top
              CarouselSlider(
                options: CarouselOptions(
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
                            fit: BoxFit.cover,
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

              const SizedBox(height: 40),

              // Content below slider
              const Center(
                child: Text(
                  'Gemstone Collection',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const WebFooter()
            ],
          ),
        ),
      ),
    );
  }
}