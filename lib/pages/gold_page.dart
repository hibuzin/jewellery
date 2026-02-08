import 'package:flutter/material.dart';
import '../layout/main_layout.dart';

class GoldPage extends StatelessWidget {
  const GoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return MainLayout(
      isMobile: isMobile,
      body: const Center(
        child: Text('Gold Collection', style: TextStyle(fontSize: 28)),
      ),
    );
  }
}