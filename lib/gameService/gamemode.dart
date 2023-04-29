import 'package:flutter/cupertino.dart';

class GameMode {

  void drawBackground(Canvas canvas) {}
  void drawTeleportPosition(Canvas canvas) {}
  void onTapDown(TapDownDetails d) {}
  void nextTurn() {}
  void gameOver() {}
  List<Offset> generatePoints(Size dimension) {}

  void moveTankRight(){}
  void moveTankLeft(){}
  static double degreeToRadian(double degree) {}
  void setAngle(double degree) {}
  void increaseAngle() {}
  void decreaseAngle() {}
  void applyShield(int level,Function updateState) {}
  void setShield(int level) {}
  void increaseHealth(Function updateState) {}
  void teleportPosition(Offset offset) {}
  void fire() async{}

  void playSound(String file) async {}
  void updateWind(){}
  // electric_ball
  int next(int min, int max){}

}