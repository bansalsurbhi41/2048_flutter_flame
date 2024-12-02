

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_game/src/my_game_2048.dart';

import '../constants/config.dart';
import '../constants/string_const.dart';
import '../enum/enum.dart';

class ScoreBoard extends TextComponent with HasGameRef<MyGame2048>{
  ScoreBoard({required super.position, required this.scoreType}): super(
    anchor: Anchor.center,
  );

final ScoreType scoreType;

  @override
  FutureOr<void> onLoad() {
    textRenderer = TextPaint(
      style: TextStyle(
          color: textColor,
          fontSize: gameRef.size.x * .09,
          fontWeight: FontWeight.bold
      ),
    );
    return super.onLoad();
  }


  @override
  void update(double dt) {
    super.update(dt);
    text =
    "${scoreType == ScoreType.maxTileValue ? StringConst.max : StringConst.score} : ${scoreType == ScoreType.maxTileValue ? gameRef.gameFunctions.maxTileValue : gameRef.gameFunctions.maxScore}";
  }

}