import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class BallFallGame extends Game {
  //Needed for Box2D
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  //Main physic object -> our game world
  World world;
  //Zero vector -> no gravity
  final Vector2 _gravity = Vector2(0, 0);

  BallFallGame(){
    world = new World.withPool(_gravity,
        DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    initialize();
  }

  //Initialize all things we need, devided by things need the size and things without
  Future initialize() async{
    //Call the resize as soon as flutter is ready
    resize(await Flame.util.initialDimensions());
  }


  void resize(Size size) {
    // TODO: implement resize
    super.resize(size);
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}