
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../src/my_game_2048.dart';

class PlayBoard extends RectangleComponent with HasGameReference<MyGame2048>{
  PlayBoard({required this.color, required this.boxSize, required this.radius}) : super(
      anchor: Anchor.center,
      size: boxSize,
      children: [RectangleComponent()]
  );

  final Color color;
  final Vector2 boxSize;
  final double radius;


  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
         Radius.circular(radius),
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

}