import 'package:flutter/material.dart';
import '../layout/main_layout.dart';

class DiamondPage extends StatelessWidget {
  const DiamondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return MainLayout(
      isMobile: isMobile,
      body: const Center(
        child: Text('Diamond Collection', style: TextStyle(fontSize: 28)),
      ),
    );
  }
}