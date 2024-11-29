import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/game_app.dart';
import 'package:flutter_game/src/my_game_2048.dart';

void main() {
  final game = MyGame2048();
  // runApp(GameWidget(game: game));
  runApp(const GameApp());
}


