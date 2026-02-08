import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../widgets/home_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return MainLayout(
      isMobile: isMobile,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeSection(title: 'HOME HERO', height: 400),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 80,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diamond Rings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isMobile ? 2 : 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: List.generate(4, (index) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text('Diamond Ring ${index + 1}'),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const HomeSection(title: 'HOME FOOTER', height: 200),
          ],
        ),
      ),
    );
  }
}