import 'dart:ui';

import 'package:flutter/material.dart';

import '../Tank.dart';
import '../explosion.dart';
import 'fire_ball.dart';

class JumpBomb extends FireBall {
  String name = "Jump Ball";
  bool isTank = false;
  bool flag = false;
  double maxRadius;
  int moveupFlag = 0;
  int count = 0;
  CustomFireBall customFireBall;

  JumpBomb({gameController, initialPosition, fireDetails})
      : super(
            gameController: gameController,
            initialPosition: initialPosition,
            fireDetails: fireDetails) {
    maxRadius = gameController.tileSize * 1.5;
    paint = Paint()..color = Colors.cyan[200];
  }

  void increaseCount() {
    count++;
    if (count == 2) {
      this.exploded = false;
      gameController.gameMode.nextTurn();
      gameController.fired = false;
    }
  }

  void render(Canvas canvas) {
    if (!exploded) {
      canvas.drawLine(position, position + Offset(5, 5), paint);
      canvas.drawLine(position + Offset(5, 5), position + Offset(5, 0), paint);
      canvas.drawLine(position + Offset(5, 0), position + Offset(0, 5), paint);
      canvas.drawLine(position + Offset(0, 5), position, paint);
    } else {
      renderExplosion(canvas);
    }
  }

  @override
  void setExplode() {
    gameController.tanks.forEach((Tank tank) {
      if (tank.alive) {
        if (tank.contain(
                Offset(position.dx, position.dy - tank.imageSize.y / 3)) ||
            tank.contain(Offset(position.dx, position.dy))) {
          print('tank on explosion position');
          isTank = true;
        }
      }
    });
    if (isTank) {
      exploded = true;
      explosion = Explosion(
          gameController: gameController,
          position: position,
          radius: maxRadius,
          damageFactor: 0.1,
          function: () {
            this.exploded = false;
            gameController.gameMode.nextTurn();
            gameController.fired = false;
            gameController.fireBall.position = Offset(-10, -10);
          });
    } else {
      exploded = true;
      explosion = Explosion(
          gameController: gameController,
          position: position,
          radius: gameController.tileSize,
          function: () {
            gameController.fireBall.position = Offset(-10, -10);
          });

      customFireBall = CustomFireBall(
          gameController: gameController,
          initialPosition: position,
          fireDetails: fireDetails,
          maxmovement: gameController.tileSize * 0.6,
          radius: gameController.tileSize,
          count: 0,
          function: increaseCount);
    }
  }

  void updateExplosion(double t) {
    if (exploded) explosion.update(t);
    if (customFireBall != null) {
      customFireBall.update(t);
    }
  }

  void renderExplosion(Canvas canvas) {
    if (exploded) explosion.render(canvas);
    if (customFireBall != null && !flag) {
      customFireBall.render(canvas);
    }
  }
}

class CustomFireBall extends FireBall {
  int Count;
  CustomFireBall customFireBall;
  double maxMovement;
  double currMovement;
  double Radius;
  bool isTank = false;
  double maxRadius;
  Function function;

  CustomFireBall(
      {gameController,
      initialPosition,
      fireDetails,
      maxmovement,
      radius,
      count,
      this.function})
      : super(
            gameController: gameController,
            initialPosition: initialPosition,
            fireDetails: fireDetails) {
    maxMovement = maxmovement;
    currMovement = 0.0;
    Radius = radius;
    paint = Paint()..color = Colors.cyan[200];
    Count = count;
    maxRadius = gameController.tileSize * 2.5;
    customFireBall = null;

    if (function == null) {
      function = () {
        exploded = false;
        position = Offset(-10, -10);
      };
    }
  }

  void render(Canvas canvas) {
    if (!exploded) {
      canvas.drawLine(position, position + Offset(5, -5), paint);
      canvas.drawLine(
          position + Offset(5, -5), position + Offset(0, -5), paint);
      canvas.drawLine(position + Offset(0, -5), position + Offset(5, 0), paint);
      canvas.drawLine(position + Offset(5, 0), position, paint);
    } else {
      renderExplosion(canvas);
    }
  }

  void setExplode() {
    gameController.tanks.forEach((Tank tank) {
      if (tank.alive) {
        if (tank.contain(
                Offset(position.dx, position.dy - tank.imageSize.y / 3)) ||
            tank.contain(Offset(position.dx, position.dy))) {
          print('tank on explosion position');
          isTank = true;
        }
      }
    });
    if (isTank) {
      exploded = true;
      explosion = Explosion(
          gameController: gameController,
          position: position,
          radius: Radius,
          damageFactor: 1.0 - (currMovement / maxMovement) * 0.1,
          function: () {
            this.exploded = false;
            gameController.gameMode.nextTurn();
            gameController.fired = false;
            gameController.fireBall.position = Offset(-10, -10);
          });
    } else {
      exploded = true;
      explosion = Explosion(
          gameController: gameController,
          position: position,
          radius: Radius,
          function: () {
//          this.exploded = false;
//          gameController.nextTurn();
//          gameController.fired = false;
//          gameController.fireBall.position = Offset(-10,-10);
          });

      if (Count < 2) {
        customFireBall = CustomFireBall(
            gameController: gameController,
            initialPosition: position,
            fireDetails: fireDetails,
            maxmovement: maxMovement - gameController.tileSize * 0.1,
            radius: Radius * 0.9,
            count: Count + 1,
            function: function);
      } else {
        explosion = Explosion(
            gameController: gameController,
            position: position,
            radius: Radius,
            function: () {
              this.exploded = false;
              gameController.gameMode.nextTurn();
              gameController.fired = false;
              gameController.fireBall.position = Offset(-10, -10);
            });
      }
    }
  }

  void updatePosition(double t) {
    time += 0.15;
    double dy;
    if (currMovement > maxMovement) {
      switch (Count) {
        case 0:
          dy = position.dy + 5;
          break;
        case 1:
          dy = position.dy + 4;
          break;
        case 2:
          dy = position.dy + 3;
          break;
        default:
          dy = position.dy + 2;
          break;
      }
    } else {
      switch (Count) {
        case 0:
          dy = position.dy - 5;
          break;
        case 1:
          dy = position.dy - 4;
          break;
        case 2:
          dy = position.dy - 3;
          break;
        default:
          dy = position.dy - 2;
          break;
      }
      currMovement++;
    }

    if (dy >= gameController.mountain.points[position.dx.toInt()].dy) {
      time -= 0.1;
      dy = position.dy - 3;
      setExplode();
    }
    position = Offset(position.dx, dy);
  }

  void updateExplosion(double t) {
    if (exploded) explosion.update(t);
    // print(Count);
    if (customFireBall != null) {
      customFireBall.update(t);
    }
  }

  void renderExplosion(Canvas canvas) {
    if (exploded) explosion.render(canvas);
    // print(Count);
    if (customFireBall != null) {
      customFireBall.render(canvas);
    }
  }
}
