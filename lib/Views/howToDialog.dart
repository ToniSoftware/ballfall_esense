import 'package:ballfall/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      title: Text(
        "How-To Ball Fall",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
              "Guide the ball through the maze. \n"
              + (sharedPrefs.getBool("eSense") ?
                  "Simply tilt your head to guide the ball"
                  : "Simply tilt your phone to guide the ball.")),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
