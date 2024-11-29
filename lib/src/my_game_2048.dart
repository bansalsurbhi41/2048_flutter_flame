
import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/components/play_area.dart';
import 'package:flutter_game/components/score_board.dart';
import 'package:flutter_game/src/game_functions.dart';

import '../components/play_board.dart';
import '../components/reset_button.dart';
import '../components/title_2048.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class MyGame2048 extends FlameGame with HorizontalDragDetector, VerticalDragDetector, TapDetector ,KeyboardEvents{
  MyGame2048({super.children}): super(
    camera:  CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    ),
  );

  late GameFunctions gameFunctions;
  bool swipingInTiles = false;
  late PlayArea bg;
  late Vector2 bgTopLeftCorner;
  final Set<LogicalKeyboardKey> _handledKeys = {};



  late PlayState _playState;

  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
        break;
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        break;
    }
  }

  @override
  FutureOr<void> onLoad(){

    camera.viewfinder.anchor = Anchor.center;
    bg = PlayArea();
    bgTopLeftCorner = bg.center + Vector2(-bg.size.x * .5, -bg.size.y * .5);
    world.add(bg);
    playState = PlayState.welcome;
    return super.onLoad();
  }

  @override
  void onTap() {
    debugPrint('Current playState: $playState');
    if (playState == PlayState.welcome || playState == PlayState.gameOver || playState == PlayState.won) {
      debugPrint('Starting the game...');
      gameStart();
    }
    super.onTap();
  }

  void gameStart() {
    if (playState == PlayState.playing) return;
    gameFunctions = GameFunctions(gameRef: this);
    playState = PlayState.playing;
    world.add(ScoreBoard(position:  Vector2(-200, -470), scoreType: ScoreType.totalScore));
    world.add(ScoreBoard(position:  Vector2(
        200, -470), scoreType: ScoreType.maxTileValue));
    world.add(PlayBoard(
      color: const Color(0xFFb8b894),
      boxSize: Vector2(size.x * .98, size.x * .98),
      radius: 20,
    ));

    gameFunctions.addTileToGameWorld();
    world.add(ResetButton(
        position: Vector2(270, -580),color: textColor, onTap: gameFunctions.reset
    ));
    world.add(Title2048(
      position: Vector2(-200, -620),color: textColor,
    ));
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    super.onHorizontalDragUpdate(info);
    if(info.eventPosition.global.x >= bgTopLeftCorner.x &&
        info.eventPosition.global.x < bgTopLeftCorner.x + bg.size.x){
      swipingInTiles = true;
    }
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    super.onVerticalDragUpdate(info);
    if(info.eventPosition.global.y > bgTopLeftCorner.y &&
        info.eventPosition.global.y < bgTopLeftCorner.y + bg.size.y){
      swipingInTiles = true;
    }
  }


  @override
  void onHorizontalDragEnd(DragEndInfo info) {
    super.onHorizontalDragEnd(info);
    if(swipingInTiles){
        if(info.velocity.x < 0){
          gameFunctions.moveTile(movingDirection: MovingDirection.left);
        }else{
          gameFunctions.moveTile(movingDirection: MovingDirection.right);
        }
      swipingInTiles = false;
    }
  }

  @override
  void onVerticalDragEnd(DragEndInfo info) {
    super.onVerticalDragEnd(info);
    if(swipingInTiles){
        if(info.velocity.y < 0){
          gameFunctions.moveTile(movingDirection: MovingDirection.up);
        }else{
          gameFunctions.moveTile(movingDirection: MovingDirection.down);
        }
      swipingInTiles = false;
    }
  }


  /* @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    print('---cvdgcv-----${info.eventPosition.global.x}');
    if(info.eventPosition.global.x >= bgTopLeftCorner.x &&
        info.eventPosition.global.x < bgTopLeftCorner.x + bg.size.x &&
        info.eventPosition.global.y > bgTopLeftCorner.y &&
        info.eventPosition.global.y < bgTopLeftCorner.y + bg.size.y){
      swipingInTiles = true;
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    if(swipingInTiles){
      if(info.velocity.x.abs() > info.velocity.y.abs()){
        if(info.velocity.x < 0){
          gameFunctions.moveTile(movingDirection: MovingDirection.left);
        }else{
          gameFunctions.moveTile(movingDirection: MovingDirection.right);
        }
      }
      else{

        if(info.velocity.y < 0){
          gameFunctions.moveTile(movingDirection: MovingDirection.up);
        }else{
          gameFunctions.moveTile(movingDirection: MovingDirection.down);
        }
      }
      swipingInTiles = false;
    }

  }*/


  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    if (event is KeyDownEvent && !_handledKeys.contains(event.logicalKey)) {
      // Only process new key presses
      _handledKeys.add(event.logicalKey);

      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          if(playState == PlayState.playing){
            gameFunctions.moveTile(movingDirection: MovingDirection.left);
          }
          break;
        case LogicalKeyboardKey.arrowRight:
          if(playState == PlayState.playing) {
            gameFunctions.moveTile(movingDirection: MovingDirection.right);
          }
          break;
        case LogicalKeyboardKey.arrowUp:
          if(playState == PlayState.playing){
            gameFunctions.moveTile(movingDirection: MovingDirection.up);
          }
          break;
        case LogicalKeyboardKey.arrowDown:
          if(playState == PlayState.playing){
            gameFunctions.moveTile(movingDirection: MovingDirection.down);
          }
          break;
        case LogicalKeyboardKey.space:
          gameStart();
        case LogicalKeyboardKey.enter:
          gameStart();
      }
    } else if (event is KeyUpEvent) {
      // Remove the key from the handled set on release
      _handledKeys.remove(event.logicalKey);
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() {
    return const Color(0xfff2e8cf);
  }
}

