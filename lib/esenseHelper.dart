import 'dart:async';
import 'dart:ui';

import 'package:esense_flutter/esense.dart';
import 'package:ballfall/game.dart';
import 'package:ballfall/Elements/ball.dart';
import 'package:flutter/widgets.dart';

class ESenseHelper {

  bool connected = false;
  String _deviceStatus = '';
  String eSenseName = 'eSense-0569';
  double gyro = 0;

  ESenseHelper() {
    _connectToESense();
  }

  Future<void> _connectToESense() async {
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      if (event.type == ConnectionType.connected) {
        Timer(Duration(seconds: 2), () async {
          _startListenToSensorEvents();
          connected = true;
        });
      }

      switch (event.type) {
        case ConnectionType.connected:
          _deviceStatus = 'connected';
          break;
        case ConnectionType.unknown:
          _deviceStatus = 'unknown';
          break;
        case ConnectionType.disconnected:
          _deviceStatus = 'disconnected';
          break;
        case ConnectionType.device_found:
          _deviceStatus = 'device_found';
          break;
        case ConnectionType.device_not_found:
          _deviceStatus = 'device_not_found';
          break;
      }
      // game.connectionStatus.updateStatus(_deviceStatus);
    });
    Timer.periodic(Duration(seconds: 4), (timer) async {
      await ESenseManager.connect(eSenseName);

      await new Future.delayed(const Duration(seconds: 3));
      if (_deviceStatus == 'device_found' || _deviceStatus == 'connected') {
        timer.cancel();
      }
    });
  }

  StreamSubscription subscription;
  void _startListenToSensorEvents() async{
    ESenseManager.setSamplingRate(10);
    subscription = ESenseManager.sensorEvents.listen((event) {
      var temp = event.toString().substring(event.toString().indexOf(", gyro") + 9, event.toString().length);
      var tempArray = temp.split(",");
      gyro = -double.parse(tempArray[1]);
      if (gyro > 1000) {
        gyro = 1000;
      } else if (gyro < -1000) {
        gyro = -1000;
      }
      /*
      if (ball != null) {
        ball.onESensorEvent();
      }
       */
    });
  }

}