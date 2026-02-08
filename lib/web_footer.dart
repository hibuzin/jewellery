import 'package:flutter/material.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      color: Colors.grey.shade900,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Footer sections - Mobile-la Column, Web-la Row
          isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutSection(),
              const SizedBox(height: 30),
              _buildQuickLinksSection(),
              const SizedBox(height: 30),
              _buildContactSection(),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAboutSection()),
              const SizedBox(width: 20),
              Expanded(child: _buildQuickLinksSection()),
              const SizedBox(width: 20),
              Expanded(child: _buildContactSection()),
            ],
          ),

          SizedBox(height: isMobile ? 30 : 40),

          // Copyright
          Center(
            child: Text(
              '© 2026 Jewellery Store. All Rights Reserved.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: isMobile ? 12 : 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text('Company Info', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text('Careers', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text('Press', style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildQuickLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text('Diamond', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text('Gold', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text('Gemstone', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        Text('Wedding Ring', style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [

        Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Email: info@jewellery.com',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 6),
        Text(
          'Phone: +91 1234567890',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 6),
        Text(
          'Address: 123 Main Street, India',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}