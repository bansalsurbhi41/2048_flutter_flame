
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/src/config.dart';

import '../src/my_game_2048.dart';

class PlayTile extends PositionComponent with DragCallbacks, HasGameReference<MyGame2048>{
  PlayTile({ required this.boxSize, required this.radius, required super.position, this.text = 0}) : super(
      anchor: Anchor.topCenter,
      size: boxSize,
      children: [RectangleComponent()]
  );

  final Vector2 boxSize;
  final double radius;
  // late TextPaint textPaint;
  int text;
  bool merged = false;

  // @override
  // FutureOr<void> onLoad() {
  //   super.onLoad();
  //   add(TileValue(
  //     position: Vector2(85, 85),
  //     value: text.toString(),
  //     color: text == 2 || text == 4 ? textColor : Colors.white
  //   ));
  // }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        Radius.circular(radius),
      ),
      Paint()
        ..color = tileColors[text]!
        ..style = PaintingStyle.fill,
    );
    if (this.text != 0) {
      TextPaint(
      style: TextStyle(
          color: text == 2 || text == 4 ? textColor : Colors.white,
          fontSize: 70,
          fontWeight: FontWeight.bold
      ),
    ).render(canvas, text.toString(), Vector2(85, 85),anchor: Anchor.center);
    }
  }


  bool isEmpty() => text == 0;
  void reset() => merged = false;


  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2(gameWidth - 50, gameWidth - 50),
      EffectController(duration: 0.1),
    ));
  }

}