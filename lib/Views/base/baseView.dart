import 'package:flutter/widgets.dart';
import 'package:ballfall/Views/base/viewSwitchMessage.dart';
import 'package:ballfall/Views/viewManager.dart';

enum GameView {
  MainMenuBackground,
  Playing,
  Win,
  Options,
}

abstract class BaseView {
  bool active = false;
  final GameView _view;
  final ViewManager _viewManager;
  GameView get view => _view;
  ViewManager get viewManager => _viewManager;
  
  
  BaseView(this._view,this._viewManager);

  void setActive({ViewSwitchMessage message});
  void moveToBackground({ViewSwitchMessage message});

  void render(Canvas c);
  void update(double t);
}
