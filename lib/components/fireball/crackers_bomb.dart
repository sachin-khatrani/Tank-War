import 'dart:math';
import 'dart:ui';

import 'package:tankwar/components/fire_details.dart';
import 'package:tankwar/gameService/offline.dart';

import '../Tank.dart';
import '../explosion.dart';
import 'fire_ball.dart';

class CrackersBomb extends FireBall {
  bool isTank = false;
  bool flag = false;
  double maxMovement;
  double curMovement;
  double maxRadius;
  int moveupFlag = 0;

  List<CustomFireBall> fireBalls;

  CrackersBomb({gameController, initialPosition, fireDetails})
      : super(
            gameController: gameController,
            initialPosition: initialPosition,
            fireDetails: fireDetails) {
    maxMovement = gameController.tileSize * 1.0;
    curMovement = 0.0;
    name = "Cracker Ball";
    maxRadius = gameController.tileSize * 2.5;
  }

  int count = 0;

  void increaseCount() {
    count++;
    if (count == 5) {
      this.exploded = false;
      gameController.gameMode.nextTurn();
      gameController.fired = false;
    }
  }

  void update(double t) {
    if (!exploded) {
      gameController.tanks.forEach((Tank tank) {
        if (tank.alive) {
          if (tank.contain(position)) {
            setExplode();
          }
        }
      });
      if (!exploded) {
        try {
          if (position.dx <= 0 &&
              position.dx >= gameController.mountain.points.length) {
            position = Offset(-10, -10);
            gameController.fired = false;
            gameController.gameMode.nextTurn();
          } else if (moveupFlag == 1) {
            if (curMovement > maxMovement) moveupFlag = 2;
            setExplode();
          } else if ((position.dy >= gameController.playScreenSize.height ||
                  position.dy >=
                      gameController.mountain.points[position.dx.toInt()].dy) &&
              moveupFlag == 0) {
            if (explosion == null) {
              moveupFlag = 1;
              setExplode();
            }
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
    } else {
      updateExplosion(t);
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
          damageFactor: 1.0 - (curMovement / maxMovement) * 0.25,
          function: () {
            this.exploded = false;
            gameController.gameMode.nextTurn();
            gameController.fired = false;
            gameController.fireBall.position = Offset(-10, -10);
          });
    } else {
      if (curMovement < maxMovement) {
        moveUp();
      } else {
        moveupFlag = 2;
        exploded = true;
        explosion = Explosion(
            gameController: gameController,
            position: position,
            radius: gameController.tileSize / 2,
            function: () {
              gameController.fireBall.position = Offset(-10, -10);
            });
        fireBalls = List<CustomFireBall>();
        double power = 20.0;
        double angle = 75;
        double delta = 15.0;
        double prev = 0.0;
        for (int i = 0; i < 5; i++) {
          fireBalls.add(CustomFireBall(
              gameController: gameController,
              initialPosition: position,
              fireDetails: FireDetails(
                  angle: Offline.degreeToRadian((angle + delta * i) % 180),
                  power: power),
              function: increaseCount));
        }
      }
    }
  }

  void renderExplosion(Canvas canvas) {
    if (exploded) explosion.render(canvas);
    if (fireBalls != null && !flag) {
      fireBalls.forEach((CustomFireBall fireBall) {
//        print('fireballs[${fireBalls.indexOf(fireBall)}].render');

        fireBall.render(canvas);
      });
    }
  }

  void updateExplosion(double t) {
    if (exploded) explosion.update(t);
    if (fireBalls != null) {
//      print('fireballs.update');
      fireBalls.forEach((CustomFireBall fireBall) {
        fireBall.update(t);
      });
    }
  }

  void moveUp() {
    if (position.dy - 1 > 0) {
      position = Offset(position.dx, position.dy - 3);
      curMovement++;
    } else {
      setExplode();
    }
  }
}

class CustomFireBall extends FireBall {
  Function function;
  static Random random = new Random();

  CustomFireBall({gameController, initialPosition, fireDetails, this.function})
      : super(
            gameController: gameController,
            initialPosition: initialPosition,
            fireDetails: fireDetails) {
    if (function == null) {
      function = () {
        exploded = false;
        position = Offset(-10, -10);
      };
    }
  }

  void render(Canvas canvas) {
    if (!exploded) {
      Paint paint = new Paint()
        ..color = Color.fromARGB(
            255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
      rect = Rect.fromCenter(center: position, width: radius, height: radius);
      canvas.drawOval(rect, paint);
    } else {
      renderExplosion(canvas);
    }
  }

  void update(double t) {
    if (!exploded) {
      gameController.tanks.forEach((Tank tank) {
        if (tank.alive) {
          if (tank.contain(position)) {
            setExplode();
          }
        }
      });
      if (!exploded) {
        try {
          if (position.dy >= gameController.playScreenSize.height ||
              position.dy >=
                  gameController.mountain.points[position.dx.toInt()].dy ||
              position.dx <= 0 ||
              position.dx >= gameController.mountain.points.length) {
            if (explosion == null) {
              setExplode();
            }
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
    } else {
      updateExplosion(t);
    }
  }

  void setExplode() {
    exploded = true;
    explosion = Explosion(
        gameController: gameController,
        position: position,
        function: function,
        radius: gameController.tileSize / 2.5);
  }
}
