import 'dart:ui';
import 'dart:async';
import 'package:ballfall/main.dart';
import 'package:box2d_flame/box2d.dart';
import 'package:ballfall/game.dart';
import 'package:esense_flutter/esense.dart';
import 'package:sensors/sensors.dart';

class Ball {
  final BallFallGame game;
  //Physic objects
  Body body;
  CircleShape shape;
  //Scale to get from rad/s to something in the game, I like the number 5
  double sensorScale = 3;
  double eSenseScale = 1000.0;
  //Draw class
  Paint paint;
  //Initial acceleration -> no movement as its (0,0)
  Vector2 acceleration = Vector2.zero();
  double finalScale = 0;
  //eSense Stuff
  bool eSense = sharedPrefs.getBool("eSense") ?? false;
  double gyro = 0;
  StreamSubscription subscription;

  //Generate the ball and physics behind
  Ball(this.game, Vector2 position) {
    print("using earables: " + eSense.toString());
    finalScale = game.screenSize.width /  game.scale;
    shape = CircleShape(); //build in shape, just set the radius
    shape.p.setFrom(Vector2.zero());
    shape.radius = .1; //10cm ball

    paint = Paint();
    paint.color = Color(0xffffffff);

    BodyDef bd = BodyDef();
    bd.linearVelocity = Vector2.zero();
    bd.position = position;
    bd.fixedRotation = false;
    bd.bullet = false;
    bd.type = BodyType.DYNAMIC;
    body = game.world.createBody(bd);
    body.userData = this;

    FixtureDef fd = FixtureDef();
    fd.density = 10;
    fd.restitution = 0;
    fd.friction = 0;
    fd.shape = shape;
    body.createFixtureFromFixtureDef(fd);
    //Link to the sensor using dart Stream
    gyroscopeEvents.listen((GyroscopeEvent event) {
      //Adding up the scaled sensor data to the current acceleration
      if(!game.pauseGame && !eSense && !over){
        acceleration.add(Vector2(event.y / sensorScale, 0 /*event.x / sensorScale*/));
      }
    });

    //Link to the eSense earables
    if (eSense && eSenseHelper.connected) {
      ESenseManager.setSamplingRate(10);
      subscription = ESenseManager.sensorEvents.listen((event) {
        var temp = event.toString().substring(
            event.toString().indexOf(", gyro") + 9, event
            .toString()
            .length);
        var tempArray = temp.split(",");
        gyro = -double.parse(tempArray[1]);
        if (gyro > 1000) {
          gyro = 1000;
        } else if (gyro < -1000) {
          gyro = -1000;
        }
        onESensorEvent();
      });
    }
  }
  //Draw the ball
  void render(Canvas c) {
    c.save();
    //Move the canvas point 0,0 to the top left edge of our ball
    c.translate(body.position.x, body.position.y);
    //Simply draw the circle
    c.drawCircle(Offset(0, 0), .1, paint);
    c.restore();
  }

  bool over = false;
  void update(double t) {
    //Our ball has to move, every frame by its acceleration. If frame rates drop it will move slower...
    body.applyForceToCenter(acceleration);
    
    if (!over && !game.screenRect
        .overlaps(Rect.fromLTWH(body.position.x * finalScale, body.position.y * finalScale, .1, .1))) {
      body.linearVelocity = Vector2.zero();
      over = true;
      if (eSense && eSenseHelper.connected) {
        subscription.cancel();
      }
      game.pop();
    }
  }

  void onESensorEvent() {
    if (!game.pauseGame && eSense && eSenseHelper.connected && !over) {
      if ( (acceleration.x).abs() <=1 ) {
        acceleration.add(Vector2((gyro / 1000), 0));
      } else if (acceleration.x > 0.7) {
        acceleration.add(Vector2(gyro.abs() / 1000, 0));
      } else if (acceleration.x < - 0.7) {
        acceleration.add(Vector2(gyro.abs() / 1000, 0));
      }
      print("acceleration: " + acceleration.toString());
    }
  }

}
