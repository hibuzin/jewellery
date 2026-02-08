import 'package:flutter/material.dart';
import 'package:jewellery/web_footer.dart';
import '../layout/main_layout.dart';

class WeddingRingPage extends StatelessWidget {
  const WeddingRingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header + Nav + Content
          Expanded(
            child: MainLayout(
              isMobile: isMobile,
              body: const Center(
                child: Text(
                  'WeddingRingPage Collection',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
          ),

          // ✅ Web footer
          const WebFooter(),
        ],
      ),
    );
  }
}