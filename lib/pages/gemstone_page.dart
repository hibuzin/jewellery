import 'package:flutter/material.dart';
import '../layout/main_layout.dart';

class GemstonePage extends StatelessWidget {
  const GemstonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return MainLayout(
      isMobile: isMobile,
      body: const Center(
        child: Text('Gemstone Collection', style: TextStyle(fontSize: 28)),
      ),
    );
  }
}