import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/Controllers/controller_status.dart';
import 'package:tankwar/Shield/SuperShield.dart';
import 'package:tankwar/Shield/normalShield.dart';
import 'package:tankwar/Shield/strongShield.dart';
import 'package:tankwar/Shield/weakShield.dart';
import 'package:tankwar/components/Tank.dart';
import 'package:tankwar/components/ball_factory.dart';
import 'package:tankwar/components/fire_details.dart';
import 'package:tankwar/components/game_status.dart';
import 'package:tankwar/components/mountain_generator.dart';
import 'package:tankwar/components/robot.dart';
import 'package:tankwar/components/weapons.dart';
import 'package:tankwar/gameService/gamemode.dart';
import 'package:tankwar/game_controller.dart';

class Offline implements GameMode {
  final GameController gameController;
  final random = new Random();
  Robot robot;

  Offline({this.gameController}) {
    robot = Robot(gameController);
  }

  void drawBackground(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, gameController.playScreenSize.width,
        gameController.playScreenSize.height);
    Gradient gradient = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
        colors: [Colors.black, Colors.deepPurple[900]]);
    Paint paint = new Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void drawTeleportPosition(Canvas canvas) {
    Offset myPos = Offset(
        gameController.teleportPosition.dx,
        gameController
            .mountain.points[gameController.teleportPosition.dx.toInt()].dy);
    Rect rect =
    Rect.fromCircle(center: myPos, radius: gameController.tileSize / 5);
    Paint paint = new Paint()..color = Colors.grey;
    canvas.drawOval(rect, paint);
  }

  void onTapDown(TapDownDetails d) {
    if (gameController.controllerStatus == ControllerStatus.confirming &&
        gameController.isTeleport == true) {
      print(d.globalPosition);
      if (d.globalPosition.dy <= gameController.playScreenSize.height) {
        gameController.teleportPosition = d.globalPosition;
      }
    }
  }

  void nextTurn() {
    print('next turn is called');
    updateWind();
    if (gameController.alivePlayer <= 1) {
      gameOver();
    } else {
      gameController.turn =
          (gameController.turn + 1) % gameController.tanks.length;
//      gameController.tank = gameController.tanks[gameController.turn];
      if (!gameController.tank.alive)
        nextTurn();
      if(gameController.tank.isBot) {
        robot.play();
      }
    }
    gameController.updateGameState();
  }

  void botTurn() {

  }

  void gameOver() {
    print('Winner: ${gameController.tank.color}');
    gameController.tanks.forEach((Tank tank) {
      tank.alive = true;
      tank.health = 100;
      tank.fuel = 250;
      tank.fireDetails = FireDetails(
        power: 50.0,
        angle: degreeToRadian(45),
      );
    });
    gameController.alivePlayer = gameController.tanks.length;
    updateTurns();
    gameController.mountain = Mountain(gameController);
    gameController.gameStatus = Status.roundOver;
    gameController.isFirstBot = false;
    gameController.updateGameState();
  }

  void updateTurns() {
    gameController.tanks.sort((a,b) => a.totalScore.compareTo(b.totalScore));
    gameController.turn = 0;
//    gameController.tank = gameController.tanks[0];
    int n = gameController.tanks.length;
    int curSize = gameController.screenSize.width ~/ n;
    Random random = Random();
    for(int i=0;i<n;i++) {
      if(i % 2 == 0) {
        int pos;
        if(i == 0) {
          pos = random.nextInt(curSize) + curSize * i + gameController.tank.imageSize.toOffset().dx.toInt();
        } else {
          pos = random.nextInt(curSize) + curSize * i;
        }
        gameController.tanks[i].position = gameController.mountain.points[pos];
      } else {
        int pos;
        if(i == 1) {
          pos = random.nextInt(curSize) + curSize*(n-i) - gameController.tank.imageSize.toOffset().dx.toInt();
        } else {
          pos = random.nextInt(curSize) + curSize*(n-i);
        }
        gameController.tanks[i].position = gameController.mountain.points[pos];
      }
    }
  }

  List<Offset> generatePoints(Size dimension) {
    Random random = Random();
    List<Equation> equations = List<Equation>();
    int numberOfEquation = random.nextInt(8) + 3;
    for (int i = 0; i < numberOfEquation; i++) {
      double amplitude = random.nextInt(dimension.height ~/ 8).toDouble();
      double shift = random.nextInt(10) * random.nextDouble();
      double divider = random.nextDouble() * 20;
      equations.add(Equation(amplitude, shift, dimension.height / 2,
          dimension.width, divider)); //random.nextDouble()*100)
    }
    List<Offset> points = List(dimension.width.toInt());
    double height;
    for (int i = 0; i < points.length; i++) {
      height = dimension.height / 2;
      if (height < 0) height = 0;
      equations.forEach((Equation equation) {
        height += equation.getValue(i);
      });
      points[i] = Offset(i.toDouble(), height);
    }

    return points;
  }

  void moveTankRight() {
    if (gameController.tank.fuel >= 1 / gameController.tank.tankPower.engine) {
      if (gameController.tank.position.dx +
              1 +
              gameController.tank.imageSize.x / 2 <
          gameController.playScreenSize.width) {
        gameController.tank.position = Offset(
            gameController.tank.position.dx + 1,
            gameController.mountain
                .points[gameController.tank.position.dx.toInt() + 1].dy);
        gameController.tank.fuel -= 1 / gameController.tank.tankPower.engine;
      } else {
        gameController.tank.fuel = 0;
      }
    }
  }

  void moveTankLeft() {
    if (gameController.tank.fuel >= 1 / gameController.tank.tankPower.engine) {
      if (gameController.tank.position.dx -
              1 -
              gameController.tank.imageSize.x / 2 >
          0) {
        gameController.tank.position = Offset(
            gameController.tank.position.dx - 1,
            gameController.mountain
                .points[gameController.tank.position.dx.toInt() - 1].dy);
        gameController.tank.fuel -= 1 / gameController.tank.tankPower.engine;
      } else {
        gameController.tank.fuel = 0;
      }
    }
  }

  static double degreeToRadian(double degree) {
    return degree * 3.14 / 180;
  }

  void setAngle(double degree) {
    gameController.tank.fireDetails.angle = degreeToRadian(degree);
  }

  void increaseAngle() {
    gameController.tank.fireDetails.angle = degreeToRadian(
        (1 + gameController.tank.fireDetails.angle * 180 / 3.14) % 360);
    gameController.tank.fireDetails.angle += 3.14 / 180;
  }

  void decreaseAngle() {
    double temp = gameController.tank.fireDetails.angle * 180 / 3.14 - 1;
    gameController.tank.fireDetails.angle =
        degreeToRadian(temp > 0 ? temp : 360);
  }

  void applyShield(int level, Function updateState) {
    if (gameController.tank.shieldDetails == null) {
      int isShieldAvailable = 0;
      if (level == 1 && gameController.tank.accessories.weakShield > 0) {
        isShieldAvailable = 1;
      } else if (level == 2 &&
          gameController.tank.accessories.normalShield > 0) {
        isShieldAvailable = 1;
      } else if (level == 3 &&
          gameController.tank.accessories.strongShield > 0) {
        isShieldAvailable = 1;
      } else if (level == 4 &&
          gameController.tank.accessories.superShield > 0) {
        isShieldAvailable = 1;
      }

      if (isShieldAvailable == 1) {
        gameController.isShieldSelection = true;
        setShield(level);
        gameController.prevControllerStatus = gameController.controllerStatus;
        gameController.controllerStatus = ControllerStatus.confirming;
        print('confirm controller');
        updateState();
      } else {
        print('Not Sufficient Shields');
      }
    } else {
      gameController.isShieldSelection = false;
      gameController.prevControllerStatus = gameController.controllerStatus;
      gameController.controllerStatus = ControllerStatus.confirming;
      print('confirm controller');
      updateState();
    }
  }

  void setShield(int level) {
    if (level == 1) {
      gameController.tank.shieldDetails = new WeakShield();
    } else if (level == 2) {
      gameController.tank.shieldDetails = new NormalShield();
    } else if (level == 3) {
      gameController.tank.shieldDetails = new StrongShield();
    } else if (level == 4) {
      gameController.tank.shieldDetails = new SuperShield();
    }
  }

  void increaseHealth(Function updateState) {
    if(gameController.tank.accessories.repairKit > 0) {
      updateState();
      print('Health Increased');
    } else {
      print('No more repair kits');
    }
  }

  void teleportPosition(Offset offset) {
    gameController.tank.position = offset;
//    function();
  }

  void fire() async {
    try {
      AudioCache audioCache = AudioCache();
      String localFilePath = 'sounds/fire.mp3';
      print('Play start');
      await audioCache.play(localFilePath);
      print('Play ends');
    } catch (e) {
      print(e);
    }
    if (!gameController.fired) {
      int weaponIndex = gameController.tank.accessories.weapons.indexWhere(
              (Weapon weapon) =>
          (weapon.name == gameController.tank.selectedWeapon));
      print(weaponIndex);
      print(gameController.tank.selectedWeapon);
      gameController.tank.accessories.weapons[weaponIndex].quantity--;
      gameController.fired = true;
      gameController.fireBall.initialPosition =
          gameController.tank.canonPosition;
      gameController.fireBall = BallFactory.getBall(
          gameController: gameController,
          initialPosition: gameController.tank.canonPosition,
          fireDetails: gameController.tank.fireDetails,
          name: gameController.tank.selectedWeapon);
      if (gameController.tank.accessories.weapons[weaponIndex].quantity == 0) {
        gameController.tank.selectedWeapon = "Fire Ball";
      }
      gameController.tank.accessories.weapons[0].quantity = 99;
    }
  }

  void playSound(String file) async {
    try {
      AudioCache audioCache = AudioCache();
      String localFilePath = 'sounds/'+file;
      print('Play start');
      await audioCache.play(localFilePath);
      print('Play ends');
    } catch (e) {
      print('$e in sound');
    }
  }

  void updateWind() {
    double temp = random.nextDouble() * gameController.wind.maxChange;
    temp = (random.nextInt(100) % 2 == 0 ? temp : -temp);
    temp += gameController.wind.windPower;
    if (!gameController.wind.windInRange(temp))
      updateWind();
    else {
      gameController.wind.windPower = temp;
      gameController.wind.updateWind();
    }
  }

  int next(int min, int max) => min + random.nextInt(max - min);
}
