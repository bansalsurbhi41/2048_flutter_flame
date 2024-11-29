import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'config.dart';

class OverlayWonOverScreen extends StatelessWidget {
  const OverlayWonOverScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff).withOpacity(0.3),
      alignment: const Alignment(0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 70,
                color: overLayTextColor
            ),
          ).animate().slideY(duration: 750.ms, begin: -3, end: 0),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}