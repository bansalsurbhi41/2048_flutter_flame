

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/constants/config.dart';

import '../src/my_game_2048.dart';

class PlayTile extends PositionComponent with DragCallbacks, HasGameReference<MyGame2048>{
  PlayTile({ required this.boxSize, required this.radius, required super.position, this.value = 0}) : super(
      anchor: Anchor.topCenter,
      size: boxSize,
      children: [RectangleComponent()]
  );

  final Vector2 boxSize;
  final double radius;
  int value;
  bool merged = false;

  // @override
  // FutureOr<void> onLoad() {
  //   super.onLoad();
  //   add(TileValue(
  //     position: Vector2(85, 85),
  //     value: value.toString(),
  //     color: value == 2 || value == 4 ? textColor : Colors.white
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
        ..color = tileColors[value]!
        ..style = PaintingStyle.fill,
    );
    if (value != 0) {
      TextPaint(
      style: TextStyle(
          color: value == 2 || value == 4 ? textColor : Colors.white,
          fontSize: 70,
          fontWeight: FontWeight.bold
      ),
    ).render(canvas, value.toString(), Vector2(85, 85),anchor: Anchor.center);
    }
  }


  bool isEmpty() => value == 0;
  void reset() => merged = false;


  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2(gameWidth - 50, gameWidth - 50),
      EffectController(duration: 0.1),
    ));
  }

}