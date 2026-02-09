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
        vertical: isMobile ? 20 : 60, // reduced mobile vertical padding
        horizontal: isMobile ? 16 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Footer sections - Mobile: Column, Web: Row
          isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAboutSection(isMobile: true),
              const SizedBox(height: 16), // reduced spacing
              _buildQuickLinksSection(isMobile: true),
              const SizedBox(height: 16),
              _buildContactSection(isMobile: true),
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

          SizedBox(height: isMobile ? 16 : 40),

          // Copyright
          Center(
            child: Text(
              '© 2026 Jewellery Store. All Rights Reserved.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: isMobile ? 11 : 14, // smaller on mobile
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('Company Info', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Careers', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Press', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
      ],
    );
  }

  Widget _buildQuickLinksSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('Diamond', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Gold', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Gemstone', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Wedding Ring', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
      ],
    );
  }

  Widget _buildContactSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('Email: info@jewellery.com', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Phone: +91 1234567890', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
        const SizedBox(height: 4),
        Text('Address: 123 Main Street, India', style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14)),
      ],
    );
  }
}