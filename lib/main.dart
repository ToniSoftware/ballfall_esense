import 'package:ballfall/esenseHelper.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ballfall/Views/mainMenu.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



SharedPreferences sharedPrefs;
ESenseHelper eSenseHelper;

void main() async {
  //Make sure flame is ready before we launch our game
  await setupFlame();
  runApp(App());
}

/// Setup all Flame specific parts
Future setupFlame() async {
  WidgetsFlutterBinding.ensureInitialized(); //Since flutter upgrade this is required
  sharedPrefs = await SharedPreferences.getInstance();
  eSenseHelper = new ESenseHelper();
  var flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(
      DeviceOrientation.portraitUp); //Force the app to be in this screen mode
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

