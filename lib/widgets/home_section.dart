import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final double height;

  const HomeSection({
    super.key,
    required this.title,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}