import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:ballfall/Elements/ball.dart';
import 'package:ballfall/Elements/wallBuilder.dart';
import 'package:ballfall/Elements/wall.dart';
import 'package:ballfall/Views/base/baseView.dart';
import 'package:ballfall/Views/viewManager.dart';
import 'package:ballfall/helper.dart';
import 'package:ballfall/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base/viewSwitchMessage.dart';

class PlayingView extends BaseView {
  Ball player;
  bool _initRequired = true;

  WallBuilder wallBuilder;

  PlayingView(GameView view, ViewManager viewManager)
      : super(view, viewManager);

  @override
  void setActive({ViewSwitchMessage message}) {
    if (_initRequired) {
      _initRequired = false;
      //Generate our test ball at the scaled center of the screen
      player = Ball(
          viewManager.game,
          scaleVectoreBy(Vector2(Wall.wallWidth * 4, Wall.wallWidth * 4),
              viewManager.game.screenSize.width / viewManager.game.scale));
      initMaze();
    }
  }
  void initMaze()  {
    var savedHeight = sharedPrefs.getInt("maze_height") ?? 8;
    var savedWidth = sharedPrefs.getInt("maze_width") ?? 8;
    wallBuilder = WallBuilder(
      this.viewManager.game,
      height: savedHeight,
      width: savedWidth,
    );
    wallBuilder.generateMaze();
  }

  @override
  void moveToBackground({ViewSwitchMessage message}) {
    // TODO: implement moveToBackground
  }

  @override
  void render(Canvas c) {
    player?.render(c);
    wallBuilder?.render(c);
  }

  @override
  void update(double t) {
    player?.update(t);
  }
}
