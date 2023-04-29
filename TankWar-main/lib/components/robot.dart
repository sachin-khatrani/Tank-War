import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tankwar/components/Tank.dart';
import 'package:tankwar/components/fireball/fire_ball.dart';
import 'package:tankwar/game_controller.dart';

class Robot {
  final GameController gameController;
  List<bool> selected;

  Tank get _tank => gameController.tank;

  List<Tank> get _tanks => gameController.tanks;

  Robot(this.gameController);

  void play() {
    print('play called');

    selected = List<bool>.filled(_tanks.length, false, growable: false);
    selected[_tanks.indexOf(_tank)] = true;
    int count = 1;
    int index;

    while (true) {
      index = _closestTank();
      if (index == -1) break;
      if (_calculate(index)) break;
    }
  }

  bool _calculate(int index) {
    print('calculate called');
    for (double time = 0; time < 10; time = time + 0.2) {
      double x = _tanks[index].position.dx -
          _tank.position.dx -
          0.04 * gameController.wind.windPower * time * time;
      double y = _tank.temp -
          _tank.imageSize.y -
          _tanks[index].temp +
          0.5 * gameController.wind.gravity * time * time;
      // double a1 = atan(x/-y);
      double angle = atan2(y, x);
      if (angle < 0) continue;
      double power = (x / cos(angle) - _tank.tileSize * 0.5) /
          (time * FireBall.powerFactor);

      if (power < 0 || power > 100) {
        continue;
      }

      print('Angle: ${angle * 180 / pi} Power: $power');
      if (checkMountainEdge(angle, power, time)) {
        _tank.fireDetails.angle = angle;
        _tank.fireDetails.power = power;
        gameController.gameMode.fire();
        return true;
      }
    }

    return false;
  }

  int _closestTank() {
    double distance = double.maxFinite;
    int index = -1;
    for (int i = 0; i < _tanks.length; i++) {
      if (selected[i] || !_tanks[i].alive) continue;
      double temp =
          (Offset(_tank.position.dx, _tank.temp) - _tanks[i].position).distance;
      if (temp < distance) {
        distance = temp;
        index = i;
      }
    }
    if (index != -1) {
      selected[index] = true;
    } else {
      // TODO: Default
      gameController.gameMode.setAngle(45);
      _tank.fireDetails.power = 55;
      gameController.gameMode.fire();
    }
    return index;
  }

  bool checkMountainEdge(double angle, double power, double endTime) {
    for (double time = 0; time < endTime; time = time + 0.01) {
      Offset temp = getOffset(time, angle, power);
      try {
        if (temp.dy > gameController.mountain.points[temp.dx.toInt()].dy ||
            temp.dx < 0 ||
            temp.dx >= gameController.mountain.length) return false;
      } catch (e) {
        print(e);
        return false;
      }
    }
    return true;
  }

  Offset getOffset(double time, double angle, double power) {
    double x = _tank.position.dx +
        gameController.tileSize * 0.5 * cos(angle) +
        FireBall.powerFactor * power * cos(angle) * time +
        0.04 * gameController.wind.windPower * time * time;

    double y = _tank.temp -
        _tank.imageSize.y -
        gameController.tileSize * 0.5 * sin(angle) -
        FireBall.powerFactor * power * sin(angle) * time +
        0.5 * gameController.wind.gravity * time * time;

    return Offset(x, y);
  }
}
