
import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_game/constants/config.dart';

import '../src/my_game_2048.dart';

class PlayArea extends RectangleComponent with HasGameReference<MyGame2048>{
  PlayArea() : super(
    paint: Paint()..color = playAreaColor,
    anchor: Anchor.center,
    children: [RectangleComponent()]
  );

  @override
  FutureOr<void> onLoad() async{
    super.onLoad();
    size = Vector2(gameWidth, gameHeight);
  }
}