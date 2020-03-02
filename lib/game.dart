import 'dart:ui';
import 'package:ballfall/main.dart';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ballfall/Views/base/baseView.dart';
import 'package:ballfall/Views/base/viewSwitchMessage.dart';
import 'package:ballfall/Views/viewManager.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ballfall/esenseHelper.dart';
import 'dart:async' as timer;

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  BallFallGame game;
  bool eSense = sharedPrefs.getBool("eSense") ?? false;

  _GameWidgetState() {
    game = new BallFallGame();
  }

  @override
  void initState() {
    super.initState();
    game.pop = () {
      Navigator.pop(context);
    };
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    if (eSense) {
        if (!eSenseHelper.connected) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            title: Text(
              "Connecting to eSense...",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.0),
            ),
            content: Text(
                "They are currently: " + (eSenseHelper.connected ? "connected" : "disconnected") +
                "\nPlease go back and try again once they are connected!"
            ),
          );
        } else if (eSenseHelper.connected) {
          return Scaffold(
            body: Stack(children: <Widget>[
              game.widget,
            ]),
          );
        }
    } else {
      return Scaffold(
        body: Stack(children: <Widget>[
          game.widget,
        ]),
      );
    }
  }
}

class BallFallGame extends Game {
  //Needed for Box2D
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  //Main physic object -> our game world
  World world;
  //Zero vector -> no gravity
  final Vector2 _gravity = Vector2(0, 10);
  //Scale factore for our world
  final int scale = 5;
  //Size of the screen from the resize event
  Size screenSize;
  //Rectangle based on the size, easy to use
  Rect _screenRect;
  Rect get screenRect => _screenRect;
  //Handle views and transition between
  ViewManager _viewManager;

  //Handle eSense earables via bluetooth
  ESenseHelper eSenseHelper;

  bool pauseGame = false;
  bool blockResize = false;
  bool eSense = false;
  Vector2 acceleration = Vector2.zero();

  BallFallGame({GameView startView = GameView.Playing}) {
    world = new World.withPool(
        _gravity, DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    initialize(startView: startView);
  }

  //Initialize all things we need, divided by things need the size and things without
  Future initialize({GameView startView = GameView.Playing}) async {
    //Call the resize as soon as flutter is ready
    resize(await Flame.util.initialDimensions());
    _viewManager = ViewManager(this);
    _viewManager.changeView(startView);
  }

  void resize(Size size) {
    if(blockResize && screenSize !=null)
    {
      return;
    }
    //Store size and related rectangle
    screenSize = size;
    _screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    super.resize(size);
  }

  @override
  void render(Canvas canvas) {
    //If no size information -> leave
    if (screenSize == null || pauseGame) {
      return;
    }
    //Save the canvas and resize/scale it based on the screenSize
    canvas.save();
    canvas.scale(screenSize.width / scale);
    _viewManager?.render(canvas);
    //Finish the canvas and restore it to the screen
    canvas.restore();
  }

  @override
  void update(double t) {
    if (screenSize == null || pauseGame) {
      return;
    }

    //Run any physic related calculation
    world.stepDt(t, 100, 100);
    _viewManager?.update(t);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      pauseGame = true;
      Wakelock.disable();
    }
    else{
      Wakelock.enable();
      pauseGame = false;
    }
  }

  void sendMessageToActiveState(ViewSwitchMessage message) async{
    _viewManager.activeView?.setActive(message: message);
  }

  Function() pop;

}
