import 'dart:async';
import 'dart:ui';

import 'package:esense_flutter/esense.dart';
import 'package:ballfall/game.dart';

class ESenseHelper {

  final BallFallGame game;
  bool connected = false;
  String _deviceStatus = '';
  String eSenseName = 'eSense-0569';
  double gyro;

  ESenseHelper(this.game) {
    _connectToESense();
  }

  Future<void> _connectToESense() async {
    ESenseManager.connectionEvents.listen((event) {

      print('CONNECTION event: $event');

      if(event.type == ConnectionType.connected) {
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

      await new Future.delayed(const Duration(seconds : 3));
      if(_deviceStatus == 'device_found' || _deviceStatus == 'connected') {
        timer.cancel();
      }
    });
  }

  StreamSubscription subscription;
  void _startListenToSensorEvents() async{
    subscription = ESenseManager.sensorEvents.listen((event) {
      var temp = event.toString().substring(event.toString().indexOf(", gyro") + 9, event.toString().length);
      var tempArray = temp.split(",");
      gyro = double.parse(tempArray[1].toString());
    });
  }


}