import 'package:flutter/material.dart';
import 'package:jewellery/pages/home_page.dart';
import '../pages/diamond_page.dart';
import '../pages/gold_page.dart';
import '../pages/gemstone_page.dart';
import '../pages/wedding_ring_page.dart';

class NavBarDelegate extends SliverPersistentHeaderDelegate {
  final bool isMobile;

  NavBarDelegate({required this.isMobile});

  @override
  double get minExtent => 52;

  @override
  double get maxExtent => 52;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Center( // 👈 Center the row inside the scrollable
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _item(context, 'HOME', const HomePage()),
              _item(context, 'GOLD', const GoldPage()),
              _item(context, 'GEMSTONE', const GemstonePage()),
              _item(context, 'WEDDING RING', const WeddingRingPage()),
              _item(context, 'PLATINUM', const GoldPage()),
              _item(context, 'ROSE GOLD', const GoldPage()),
              _item(context, 'RING', const GoldPage()),
              _item(context, '24CRT', const GoldPage()),
              _item(context, 'DIAMOND', const DiamondPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_) => false;
}