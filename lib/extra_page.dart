//
// import 'dart:async';
//
// import 'package:flame/events.dart';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_game/components/play_area.dart';
// import 'package:flutter_game/components/score_board.dart';
// import 'package:flutter_game/src/game_functions.dart';
//
// import '../components/play_board.dart';
// import '../components/reset_button.dart';
// import '../components/title_2048.dart';
// import 'config.dart';
//
// enum PlayState { welcome, playing, gameOver, won }
//
// class MyGame2048 extends FlameGame with PanDetector, TapDetector ,KeyboardEvents{
//   MyGame2048({super.children}): super(
//     camera:  CameraComponent.withFixedResolution(
//       width: gameWidth,
//       height: gameHeight,
//     ),
//   );
//
//   late GameFunctions gameFunctions;
//   bool swipingInTiles = false;
//   late PlayArea bg;
//   late Vector2 bgTopLeftCorner;
//   final Set<LogicalKeyboardKey> _handledKeys = {};
//
//
//
//   late PlayState _playState;
//
//   PlayState get playState => _playState;
//
//   set playState(PlayState playState) {
//     _playState = playState;
//     switch (playState) {
//       case PlayState.welcome:
//       case PlayState.gameOver:
//       case PlayState.won:
//         overlays.add(playState.name);
//         break;
//       case PlayState.playing:
//         overlays.remove(PlayState.welcome.name);
//         overlays.remove(PlayState.gameOver.name);
//         overlays.remove(PlayState.won.name);
//         break;
//     }
//   }
//
//   @override
//   FutureOr<void> onLoad(){
//
//     camera.viewfinder.anchor = Anchor.center;
//     bg = PlayArea();
//     bgTopLeftCorner = bg.center + Vector2(-bg.size.x * .5, -bg.size.y * .5);
//     world.add(bg);
//     playState = PlayState.welcome;
//     return super.onLoad();
//   }
//
//   @override
//   void onTap() {
//     debugPrint('Current playState: $playState');
//     if (playState == PlayState.welcome || playState == PlayState.gameOver || playState == PlayState.won) {
//       debugPrint('Starting the game...');
//       gameStart();
//     }
//     super.onTap();
//   }
//
//   void gameStart() {
//     if (playState == PlayState.playing) return;
//     gameFunctions = GameFunctions(gameRef: this);
//     playState = PlayState.playing;
//     world.add(PlayBoard(
//       color: const Color(0xFFb8b894),
//       boxSize: Vector2(size.x * .98, size.x * .98),
//       radius: 20,
//     ));
//
//     gameFunctions.addTileToGameWorld();
//   }
//
//   @override
//   void onPanUpdate(DragUpdateInfo info) {
//     super.onPanUpdate(info);
//     debugPrint('Pan update detected: ${info.eventPosition.global}');
//   }
//
//   @override
//   void onPanEnd(DragEndInfo info) {
//     super.onPanEnd(info);
//     debugPrint('Pan end detected with velocity: ${info.velocity}');
//   }
//
//
//   @override
//   Color backgroundColor() {
//     return const Color(0xfff2e8cf);
//   }
// }
//
