import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:ballfall/Elements/wall.dart';
import 'package:ballfall/game.dart';
import 'package:ballfall/Elements/lineGenerator.dart';

class WallBuilder {
  //Size of the maze
  int _width;
  int _height;
  //Size for each maze cell
  Size cellSize;
  //The generator
  LineGenerator _lineGenerator;
  final BallFallGame game;
  //All walls of the maze
  final List<Wall> walls = new List();

  WallBuilder(this.game, {int width = 8, int height = 8}) {
    resetMaze(width: width,height: height,buildMaze: false);
  }
  void resetMaze({int width = 8, int height = 8, bool buildMaze = true}) {
    _width = width;
    _height = height;
    //Calculate the cell size to fit the screen
    cellSize = Size(
      game.screenSize.width / (width),
      game.screenSize.height / (height),
    );
    if (buildMaze) {
      generateMaze();
    }
  }

  void generateMaze() {
    //Clear walls
    walls.clear();
    // Add Walls for the left,right side and top
    var leftStart = Vector2(Wall.wallWidth, 0);
    var rightStart = Vector2(_width * cellSize.width - Wall.wallWidth, 0);

    // Wall for top
    walls.add(Wall(
      game,
      leftStart,
      rightStart
    ));

    // Wall for left
    walls.add(Wall(
        game,
        Vector2.zero(),
        Vector2(0, game.screenSize.height)
    ));

    // Wall for right
    walls.add(Wall(
        game,
        Vector2(game.screenSize.width - Wall.wallWidth, 0),
        Vector2(game.screenSize.width - Wall.wallWidth, game.screenSize.height)
    ));


    // Generate walls per row
    for (int y = 1; y < _height; ++y) {
      double dy = y * cellSize.height;
      _lineGenerator = new LineGenerator(_width);
      _lineGenerator.generateNewLine(_width);
      List<Vector2> wall = _lineGenerator.getStartingPoints();
      if (wall.length == 2) {
        // Wall before Gap
        walls.add(Wall(
          game,
          Vector2(wall.elementAt(0).x * cellSize.width, dy),
          Vector2(wall.elementAt(0).y * cellSize.width, dy)
        ));
        // Wall after Gap
        walls.add(Wall(
          game,
          Vector2(wall.elementAt(1).x * cellSize.width, dy),
          Vector2(wall.elementAt(1).y * cellSize.width, dy)
        ));
      }
      // Gap either at beginning or at the end
      else {
        walls.add(Wall(
          game,
          Vector2(wall.elementAt(0).x * cellSize.width + Wall.wallWidth, dy),
          Vector2(wall.elementAt(0).y * cellSize.width - Wall.wallWidth, dy)
        ));

      }
    }
  }


  //Draw all walls of the mazes
  void render(Canvas c) {
    walls.forEach((f) => f.render(c));
  }
}
