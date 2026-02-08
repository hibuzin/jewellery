import 'package:flutter/material.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade900,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Example: Footer sections
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // About section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('About Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('Company Info', style: TextStyle(color: Colors.white70)),
                  Text('Careers', style: TextStyle(color: Colors.white70)),
                  Text('Press', style: TextStyle(color: Colors.white70)),
                ],
              ),

              // Quick Links section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Quick Links', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('Diamond', style: TextStyle(color: Colors.white70)),
                  Text('Gold', style: TextStyle(color: Colors.white70)),
                  Text('Gemstone', style: TextStyle(color: Colors.white70)),
                  Text('Wedding Ring', style: TextStyle(color: Colors.white70)),
                ],
              ),

              // Contact section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('Email: info@jewellery.com', style: TextStyle(color: Colors.white70)),
                  Text('Phone: +91 1234567890', style: TextStyle(color: Colors.white70)),
                  Text('Address: 123 Main Street, India', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Copyright / bottom row
          const Center(
            child: Text(
              '© 2026 Jewellery Store. All Rights Reserved.',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}