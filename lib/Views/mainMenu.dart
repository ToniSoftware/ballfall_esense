import 'package:flutter/material.dart';
import 'package:ballfall/Views/howToDialog.dart';
import 'package:ballfall/Views/base/baseView.dart';
import 'package:ballfall/Views/option.dart';
import 'package:ballfall/game.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  BallFallGame game;
  @override
  void initState() {
    super.initState();
    game = BallFallGame(startView: GameView.MainMenuBackground);
    game.blockResize = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          game.widget,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Ball Fall",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      letterSpacing: 6,
                      color: Colors.white),
                ),
                SizedBox(height: 5),
                Container(
                  width: 120,
                  height: 60,
                    child: RaisedButton(
                      child: Text(
                          "Play",
                      style: TextStyle(
                        fontSize: 25),
                    ),
                      onPressed: () async {
                        game.pauseGame = true; //Stop anything in our background
                        await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => GameWidget()));
                        game.pauseGame =
                            false; //Restart it when the screen finishes
                      })
                ),
                SizedBox(height: 5),
                Container(
                    width: 120,
                    height: 60,
                    child: RaisedButton(
                      child: Text("Options",
                        style: TextStyle(
                            fontSize: 25),
                      ),
                      onPressed: () async {
                        game.pauseGame = true; //Stop anything in our background
                        await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => OptionScreen()));
                        game.pauseGame = false;
                      })
                ),
                SizedBox(height: 5),
                Container(
                  width: 120,
                  height: 60,
                    child: RaisedButton(
                      child: Text("How-To",
                        style: TextStyle(
                            fontSize: 25),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext buildContext) {
                              return HowToDialog();
                            });
                      })
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
