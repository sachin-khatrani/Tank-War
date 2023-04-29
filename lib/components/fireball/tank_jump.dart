import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tankwar/components/fireball/fire_ball.dart';

import '../Tank.dart';

class TankJump extends FireBall {
  String name = "TankJump Ball";
  int flag = 0;
  double currentRadius;
  bool flag1 = false;
  double incr = 2.0;

  TankJump({gameController, initialPosition, fireDetails})
      : super(
            gameController: gameController,
            initialPosition: initialPosition,
            fireDetails: fireDetails) {
    radius = 5;
    currentRadius = 0.0;
  }

  void render(Canvas canvas) {
    if (flag == 0) {
      rect = Rect.fromCenter(center: position, width: radius, height: radius);
      canvas.drawOval(rect, paint);
    } else {
      paint = Paint()
        ..color = Colors.orange[900]
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(position, currentRadius, paint);
    }
  }

  void update(double t) {
    gameController.tanks.forEach((Tank tank) {
      if (tank.alive) {
        if (tank.contain(position)) {
          flag = 1;
          radius = 40;
        }
      }
    });

    try {
      if (position.dx <= 0 &&
          position.dx >= gameController.mountain.points.length) {
        position = Offset(-10, -10);
        gameController.fired = false;
        gameController.gameMode.nextTurn();
      } else if (flag == 1) {
        if (currentRadius >= radius) {
          flag1 = true;
        }

        currentRadius += flag1 ? -incr : incr / 2;

        gameController.tanks.forEach((Tank tank) {
          if (tank.alive) {
            double check = (tank.position.dx - position.dx) *
                    (tank.position.dx - position.dx) +
                (tank.position.dy - position.dy) *
                    (tank.position.dy - position.dy);
            if (position.dx >= tank.position.dx) {
              if (((check - (currentRadius * currentRadius)) < 0) &&
                  (tank.position.dx > 15)) {
                tank.position = Offset(tank.position.dx - 5, tank.position.dy);
              }
            } else {
              if (((check - (currentRadius * currentRadius)) < 0) &&
                  (tank.position.dx < (gameController.screenSize.width - 20))) {
                tank.position = Offset(tank.position.dx + 5, tank.position.dy);
              }
            }
          }
        });

        if (currentRadius <= -1) {
          currentRadius = 0.0;
          incr = 0;
          function();
        }
      } else if (position.dy >= gameController.playScreenSize.height ||
          position.dy >=
              gameController.mountain.points[position.dx.toInt()].dy) {
        flag = 1;
        radius = 40;
      } else {
        updatePosition(t);
      }
    } catch (e) {
      print(e);
      gameController.fired = false;
      gameController.gameMode.nextTurn();
      position = Offset(-10.0, -10.0);
    }
  }

  void function() {
    this.exploded = false;
    gameController.gameMode.nextTurn();
    gameController.fired = false;
    gameController.fireBall.position = Offset(-10, -10);
  }
}
