import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/src/my_game_2048.dart';
import 'package:flutter_game/widgets/overlay_screen.dart';
import 'package:flutter_game/widgets/overlay_won_over_screen.dart';

import '../constants/config.dart';
import '../constants/string_const.dart';
import '../enum/enum.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {

  late final MyGame2048 game;

  @override
  void initState() {
    super.initState();
    game = MyGame2048();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              color: backgroundColor
            ),
          child: SafeArea(
            child: Center(
              child: FittedBox(
                child: SizedBox(
                  width: gameWidth,
                  height: gameHeight,
                  child: GameWidget.controlled(
                    gameFactory: MyGame2048.new,
                    mouseCursor: MouseCursor.uncontrolled,
                    overlayBuilderMap: {
                      PlayState.welcome.name: (context, game) => const OverlayScreen(
                        title: StringConst.tapToPlay,
                      ),
                      PlayState.gameOver.name: (context, game) => const OverlayWonOverScreen(
                        title: StringConst.gameOver,
                      ),
                      PlayState.won.name: (context, game) => const OverlayWonOverScreen(
                        title: StringConst.youWon,
                      ),
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}