

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_game/src/my_game_2048.dart';

import '../constants/string_const.dart';

class Title2048 extends TextComponent with HasGameReference<MyGame2048>{
  Title2048({required super.position,  required this.color}): super(
    anchor: Anchor.center,
    text: StringConst.gameTitle,
    textRenderer: TextPaint(
      style: TextStyle(
          color: color,
          fontSize: 150,
          fontWeight: FontWeight.bold
      ),
    ),
  );

  final Color color;

}