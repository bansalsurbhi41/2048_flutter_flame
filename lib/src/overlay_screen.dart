import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'config.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 70,
          color: overLayTextColor
        ),
      ).animate().slideY(duration: 750.ms, begin: -3, end: 0),
    );
  }
}