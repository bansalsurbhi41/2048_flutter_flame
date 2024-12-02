

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_game/src/my_game_2048.dart';

import '../constants/string_const.dart';

class ResetButton extends TextComponent with TapCallbacks ,HasGameReference<MyGame2048>{
  ResetButton({required super.position,  required this.color, required this.onTap}): super(
    anchor: Anchor.center,
    text:  StringConst.reset,
    textRenderer: TextPaint(
      style: TextStyle(
          color: color,
          fontSize: 50,
          fontWeight: FontWeight.bold
      ),
    ),
  );

final Color color;
final VoidCallback onTap;

@override
  void onTapDown(TapDownEvent event) {
    onTap();
    super.onTapDown(event);
  }

}