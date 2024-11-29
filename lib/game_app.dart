import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/src/my_game_2048.dart';
import 'package:flutter_game/src/overlay_screen.dart';
import 'package:flutter_game/src/overlay_won_over_screen.dart';

import '../src/config.dart';



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
              color: Color(0xfff2e8cf)
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
                        title: 'TAP TO PLAY',
                        subtitle: 'Use arrow keys or swipe',
                      ),
                      PlayState.gameOver.name: (context, game) => const OverlayWonOverScreen(
                        title: 'G A M E   O V E R!',
                        subtitle: 'Tap to Play Again',
                      ),
                      PlayState.won.name: (context, game) => const OverlayWonOverScreen(
                        title: 'Y O U   W O N ! ! !',
                        subtitle: 'Tap to Play Again',
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