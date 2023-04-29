import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:tankwar/Controllers/controller_status.dart';
import 'package:tankwar/Shield/SuperShield.dart';
import 'package:tankwar/Shield/normalShield.dart';
import 'package:tankwar/Shield/strongShield.dart';
import 'package:tankwar/Shield/weakShield.dart';
import 'package:tankwar/components/ball_factory.dart';
import 'package:tankwar/components/mountain_generator.dart';
import 'package:tankwar/components/weapons.dart';
import 'package:tankwar/gameService/gamemode.dart';
import 'package:tankwar/game_controller.dart';
import 'package:tankwar/models/user.dart';

class Online implements GameMode {
  final CollectionReference roomCollection =
      Firestore.instance.collection('room');
  final GameController gameController;
  final String roomId;
  int seed = 0;
  Random random;
  User user = User();
  var listener;
  String tankSnapshot = "";

  Online({this.gameController, this.roomId}) {
    roomId.codeUnits.forEach((val) => seed += val);
    print(seed);
    random = new Random(seed);
    setListner();
  }

  Future<void> setListner() async {
    listener = roomCollection.document(roomId).snapshots().listen((event) {
      var data = event.data;
      if (data['tankSnapshot'] != null &&
          data['tankSnapshot'] != tankSnapshot) {
        tankSnapshot = data['tankSnapshot'];
        Map<String, dynamic> tankData = jsonDecode(tankSnapshot);
        int index = gameController.uidToIndex[tankData['uid']];
        gameController.tanks[index].fireDetails.angle = tankData['angle'];
        gameController.tanks[index].fireDetails.power = tankData['power'];
        gameController.tank.position =
            gameController.mountain.points[tankData['position']];
        int level = tankData['shield'];
        if (level == 1) {
          gameController.tanks[index].shieldDetails = new WeakShield();
        } else if (level == 2) {
          gameController.tanks[index].shieldDetails = new NormalShield();
        } else if (level == 3) {
          gameController.tanks[index].shieldDetails = new StrongShield();
        } else if (level == 4) {
          gameController.tanks[index].shieldDetails = new SuperShield();
        }

        gameController.tank.canonPosition = Offset(
            tankData['initPosX'],
            tankData['initPosY'],
        );
        gameController.fireBall = BallFactory.getBall(
            gameController: gameController,
            initialPosition: gameController.tank.canonPosition,
            fireDetails: gameController.tank.fireDetails,
            name: tankData['fireball']);

        gameController.fireBall.initialPosition = gameController.tank.canonPosition;

        print("Pos init listener: ${gameController.fireBall.initialPosition}" );
        gameController.fired = true;
      } else {

      }
    });
  }

  @override
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

  @override
  void decreaseAngle() {
    double temp = gameController.tank.fireDetails.angle * 180 / 3.14 - 1;
    gameController.tank.fireDetails.angle =
        degreeToRadian(temp > 0 ? temp : 360);
  }

  @override
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

  @override
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

  @override
  void fire() async {
    // Jene Fire Karyu eni side fire karva
    playSound('sounds/fire.mp3');
    if (!gameController.fired) {
      int weaponIndex = gameController.tank.accessories.weapons.indexWhere(
              (Weapon weapon) =>
          (weapon.name == gameController.tank.selectedWeapon));
      print(weaponIndex);
      print(gameController.tank.selectedWeapon);
      if (gameController.tank.accessories.weapons[weaponIndex].quantity > 0) {
        gameController.tank.accessories.weapons[weaponIndex].quantity--;
        gameController.fired = true;
//      fireDetails.firePosition = canonPosition;
//        gameController.fireBall.initialPosition =
//            gameController.tank.canonPosition;

        gameController.fireBall = BallFactory.getBall(
            gameController: gameController,
            initialPosition: gameController.tank.canonPosition,
            fireDetails: gameController.tank.fireDetails,
            name: gameController.tank.selectedWeapon);
        print("Pos init: ${gameController.fireBall.initialPosition}" );
      } else {
        print('A bomb pura thy gya');
      }
    }
    int shield = 0;
    if(gameController.tank.shieldDetails != null && gameController.tank.shieldDetails.flag == true) {
      shield = gameController.tank.shieldDetails.index;
    }
    Map<String, dynamic> mp = {
      'uid': user.uid.toString(),
      'angle': gameController.tank.fireDetails.angle,
      'power': gameController.tank.fireDetails.power,
      'position': gameController.tank.position.dx.toInt(),
      'shield': shield,
      'fireball': gameController.tank.selectedWeapon,
      'initPosX': gameController.fireBall.initialPosition.dx,
      'initPosY': gameController.fireBall.initialPosition.dy,
    };
    if(gameController.tank.shieldDetails != null)
      gameController.tank.shieldDetails.flag = false;

    // upload data
    await roomCollection
        .document(roomId)
        .updateData({'tankSnapshot': jsonEncode(mp)});
  }

  @override
  void gameOver() {
    // TODO: implement gameOver

  }

  @override
  List<Offset> generatePoints(Size dimension) {
    List<Equation> equations = List<Equation>();
    int numberOfEquation = this.random.nextInt(8) + 3;
    for (int i = 0; i < numberOfEquation; i++) {
      double amplitude = this.random.nextInt(dimension.height ~/ 8).toDouble();
      double shift = this.random.nextInt(10) * this.random.nextDouble();
      double divider = this.random.nextDouble() * 20;
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

  @override
  void increaseAngle() {
    gameController.tank.fireDetails.angle = degreeToRadian(
        (1 + gameController.tank.fireDetails.angle * 180 / 3.14) % 360);
    gameController.tank.fireDetails.angle += 3.14 / 180;
  }

  @override
  void increaseHealth(Function updateState) {
    if (gameController.tank.accessories.repairKit > 0) {
      updateState();
      print('Health Increased');
    } else {
      print('No more repair kits');
    }
  }

  @override
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

  @override
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

  @override
  void nextTurn() {
    // TODO: implement nextTurn
    print('next turn is called');
    updateWind();
    if (gameController.alivePlayer <= 1) {
      gameOver();
    } else {
      gameController.turn =
          (gameController.turn + 1) % gameController.tanks.length;
//      gameController.tank = gameController.tanks[gameController.turn];
      gameController.updateGameState();
      if (!gameController.tank.alive)
        nextTurn();
    }
  }

  @override
  void onTapDown(TapDownDetails d) {
    if (gameController.controllerStatus == ControllerStatus.confirming &&
        gameController.isTeleport == true) {
      print(d.globalPosition);
      if (d.globalPosition.dy <= gameController.playScreenSize.height) {
        gameController.teleportPosition = d.globalPosition;
      }
    }
  }

  @override
  void playSound(String file) async {
    try {
      AudioCache audioCache = AudioCache();
      String localFilePath = 'sounds/' + file;
      print('Play start');
      await audioCache.play(localFilePath);
      print('Play ends');
    } catch (e) {
      print('$e in sound');
    }
  }

  @override
  void setAngle(double degree) {
    gameController.tank.fireDetails.angle = degreeToRadian(degree);
  }

  @override
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

  @override
  void teleportPosition(Offset offset) {
    gameController.tank.position = offset;
  }

  @override
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

  static double degreeToRadian(double degree) {
    return degree * 3.14 / 180;
  }

  int next(int min, int max) => min + random.nextInt(max - min);


}
