

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../components/play_tile.dart';
import 'config.dart';
import 'my_game_2048.dart';

enum MovingDirection { right, left, up, down }

class GameFunctions{
  static const double boxSize = (gameWidth / 4) - 20; // Game width divided by 4
  static const double padding = 5; // Padding between boxes
  List<PlayTile> gameTileList = [];
  List<PlayTile> tempList = [];
  List<List<PlayTile>> listOfGameTiles = [];
  final MyGame2048 gameRef;
  bool gameChange = false;
  int maxTileValue = 0, maxScore = 0;
  GameFunctions({required this.gameRef}){

    for(var i = 0; i < 4 ; i++){
      for(var j = 0; j < 4 ; j++) {
        tempList.add(PlayTile(
          position: Vector2((( padding+padding+padding+padding*22) +(j * (boxSize + padding))) - gameWidth/2 , ((padding+padding+padding+padding*2*2)+(i * (boxSize + padding))) - gameWidth/2),
          boxSize: Vector2( ((gameWidth - 20)/4)- 30 , ((gameWidth - 20)/4)- 30 ),
          radius: 20,
        ));
      }
      listOfGameTiles.add(tempList);
     gameTileList.addAll(tempList);
      tempList = [];
    }
    fillRandomTile(isFirstTime: true);
  }

  void addTileToGameWorld() {
    gameRef.world.addAll(gameTileList);
  }

  void fillRandomTile({bool isFirstTime = false}) {
    if(isFirstTime){
      FlameAudio.play('4.mp3');
    }
    // Create a random number generator
    Random random = Random();
    print("Filling a random tile");
    List<PlayTile> emptyTiles = [];
    for (var i = 0; i < 4; i++) {
      // Check if the tile is empty
      emptyTiles.addAll(listOfGameTiles[i].where((tile) => tile.isEmpty()));
    }
    int indexToFill = random.nextInt(emptyTiles.length);
    print('indexToFill1: $indexToFill');
    int randomValue = random.nextInt(100) > 10 ? 2 : 4; // 90% chance of getting 2 and 10% chance of getting 4
    emptyTiles[indexToFill].text = randomValue;
    emptyTiles.remove(emptyTiles[indexToFill]);
    maxTileValue = randomValue > maxTileValue ? randomValue: maxTileValue;
    if (isFirstTime) {

      // Generate a second random index
      int indexToFill2;
      do{
        indexToFill2 = random.nextInt(emptyTiles.length);
      } while(indexToFill2 == indexToFill);
      randomValue = random.nextInt(100) > 10 ? 2 : 4; // 90% chance of getting 2 and 10% chance of getting 4
      emptyTiles[indexToFill2].text = randomValue;
      print('indexToFill2: $indexToFill2');
      FlameAudio.play('4.mp3');
      maxTileValue = randomValue > maxTileValue ? randomValue: maxTileValue;
    }
  }

  void moveTile({required MovingDirection movingDirection}) async{
    FlameAudio.play('4.mp3');
    List<PlayTile> columnList = [];
    switch(movingDirection){
      case MovingDirection.right:
    // Right & Left: Iterates through each row (listOfGameTiles[i]) to process the tiles
      for(var i = 0; i < 4 ; i++){
        await mergeTileValue(tileList: listOfGameTiles[i].reversed.toList(),movingDirection: MovingDirection.right);//reversed because tiles move toward the end
      }
        break;
      case MovingDirection.left:
        for(var i = 0; i < 4 ; i++){
          await mergeTileValue(tileList: listOfGameTiles[i],movingDirection: MovingDirection.left);
        }
        break;
      case MovingDirection.down:
        for(var i = 0; i < 4 ; i++){
          for(var j = 0; j < 4 ; j++){
            columnList.add(listOfGameTiles[j][i]);
          }
          await mergeTileValue(tileList: columnList.reversed.toList(),movingDirection: MovingDirection.down);
          columnList = [];
        }
        break;
      default:
        for(var i = 0; i < 4 ; i++){
          for(var j = 0; j < 4 ; j++){
            columnList.add(listOfGameTiles[j][i]);
          }
          await mergeTileValue(tileList: columnList,movingDirection: MovingDirection.up);
          columnList = [];
        }
        break;
    }
    if(gameChange){
      Future.delayed(const Duration(milliseconds: 100)).then((value) async {
        fillRandomTile();
        gameChange = false;
        checkGameOver();
      });
    }

  }

  Future<void> mergeTileValue({required List<PlayTile> tileList, required MovingDirection movingDirection}) async{
    await reorderTileList(tileList: tileList,movingDirection: movingDirection);

    for(int i = 0; i < tileList.length - 1 ; i++ ){
      if(!(tileList[i].isEmpty())){
        await mergeTileWith(
          firstMergeTile: tileList[i],
          secondMergeTile: tileList[i + 1],
        );

        maxTileValue = tileList[i].text > maxTileValue ? tileList[i].text : maxTileValue;
        if(maxTileValue == 2048){
          gameRef.playState = PlayState.won;
        }
      }
    }
    await reorderTileList(tileList: tileList,movingDirection: movingDirection);
    await reorderTileList(tileList: tileList, movingDirection: movingDirection);
    for (var i = 0; i < tileList.length - 1; i++) {
      tileList[i].reset();
    }
  }

  Future<void> mergeTileWith({required PlayTile firstMergeTile, required PlayTile secondMergeTile}) async {
    if(firstMergeTile.merged == false && secondMergeTile.merged == false && firstMergeTile.text == secondMergeTile.text || firstMergeTile.text == 0){
      gameChange = true;
      if(!firstMergeTile.merged && !secondMergeTile.merged && firstMergeTile.text == secondMergeTile.text ){
        firstMergeTile.text = firstMergeTile.text + secondMergeTile.text;
        maxScore = maxScore + firstMergeTile.text;
        secondMergeTile.text = 0;
        secondMergeTile.merged = false;
        firstMergeTile.merged = true;
      }
    }
  }

  Future<void> reorderTileList(
      {required List<PlayTile> tileList,
        required MovingDirection movingDirection}) async {
    for (int i = 0; i < tileList.length; i++) {
      if (tileList[i].isEmpty()) {
        for (int j = i + 1; j < tileList.length; j++) {
          if (!(tileList[j].isEmpty())) {
            gameChange = true;
            swapTileModels(tile1: tileList[i], tile2: tileList[j]);
            break;
          }
        }
      }
    }
  }

  bool swapTileModels({required PlayTile tile1, required PlayTile tile2}) {
    int tempTileModel = tile1.text;
    tile1.text = tile2.text;
    tile2.text = tempTileModel;
    return true;
  }

  void checkGameOver() {
    // Check if there are any empty tiles
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        if (listOfGameTiles[i][j].isEmpty()) {
          return; // If there's an empty tile, the game is not over
        }
      }
    }

    // Check if any tiles can be merged in any direction
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 4; j++) {
        int currentValue = listOfGameTiles[i][j].text;
        // Check adjacent tiles
        if (i > 0 && listOfGameTiles[i - 1][j].text == currentValue) return; // Up
        if (i < 3 && listOfGameTiles[i + 1][j].text == currentValue) return; // Down
        if (j > 0 && listOfGameTiles[i][j - 1].text == currentValue) return; // Left
        if (j < 3 && listOfGameTiles[i][j + 1].text == currentValue) return; // Right
      }
    }

    // If no moves are possible, the game is over
    gameRef.playState = PlayState.gameOver;
  }


  void reset(){
    for(int i = 0; i < 4; i++){
      for(int j = 0; j < 4; j++){
        listOfGameTiles[i][j].text = 0;
        listOfGameTiles[i][j].merged = false;
      }
    }
    maxScore = 0;
    maxTileValue = 0;
    fillRandomTile(isFirstTime: true);
    gameRef.playState = PlayState.playing;
  }
}

