import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/Shield/shield.dart';
import 'package:tankwar/components/accessories.dart';
import 'package:tankwar/components/tank_power.dart';
import 'package:tankwar/game_controller.dart';

import 'explosion.dart';
import 'fire_details.dart';
import 'fireball/Ball.dart';

class Tank {
  final GameController gameController;
  bool alive = true;
  double health = 100;
  double fuel = 250;
  Offset position;
  Offset canonPosition;
  String color;
  double tileSize;
  bool isBot;
  Position imageSize;
  Sprite sprite;
  bool buttonPressed = false;
  Ball fireBall;
  bool exploded = false;
  Path tankPath;
  ShieldDetails shieldDetails;
  var image;
  FireDetails fireDetails;
  double temp;
  TankPower tankPower;
  Explosion explosion;
  String playerName;
  String selectedWeapon = 'Fire Ball';
  double totalScore = 0.0;
  double score = 0.0;
  Accessories accessories;

//  bool isMyTank;

  Path tank;

  Paint paint = Paint()..color = Colors.white;
  Paint shieldPaint = Paint();

  Tank({this.gameController, this.color, this.playerName, this.isBot}) {
    fireDetails = FireDetails(
      power: 50.0,
      angle: degreeToRadian(45),
    );
    accessories = Accessories();
//    Random random = Random();
//    int pos = random.nextInt(gameController.mountain.points.length - 25) + 15;
//    position = gameController.mountain.points[pos];
    tileSize = gameController.tileSize;
    imageSize = Position(tileSize, tileSize * 0.6);
    initiate();
  }

  void initiate() async {
//    image = _loadedTanks['$color'];
    tankPower = TankPower(gameController: gameController);
    this.sprite = Sprite('$color.png');
    tankPath = Path();

    Offset base = Offset(-imageSize.x / 2, -imageSize.y);
    List<Offset> offsets = List<Offset>();
    offsets.add(Offset(base.dx + imageSize.x * 0.3, base.dy));
    offsets.add(Offset(base.dx + imageSize.x * 0.7, base.dy));
    offsets.add(Offset(base.dx + imageSize.x, base.dy + imageSize.y * 0.55));
    offsets.add(Offset(base.dx + imageSize.x * 0.9, base.dy + imageSize.y));
    offsets.add(Offset(base.dx + imageSize.x * 0.1, base.dy + imageSize.y));
    offsets.add(Offset(base.dx, base.dy + imageSize.y * 0.55));
    tank = Path();
    tank.addPolygon(offsets, true);
  }

  void render(Canvas canvas) {
    if (alive) {
      temp = gameController.playScreenSize.height;
      for (int i = position.dx.toInt() - imageSize.x ~/ 2;
          i < position.dx.toInt() + imageSize.x / 2;
          i++) {
        temp = min(temp, gameController.mountain.points[i].dy);
      }
      sprite?.renderPosition(
          canvas, Position(position.dx - imageSize.x / 2, temp - imageSize.y),
          size: imageSize);

      canonPosition = Offset(
          position.dx + tileSize * 0.5 * cos(fireDetails.angle),
          temp - imageSize.y - tileSize * 0.5 * sin(fireDetails.angle));
      canvas.drawLine(Offset(position.dx, temp - imageSize.y), canonPosition,
          paint); // tank-head

      if (shieldDetails != null) {
        Offset shieldPos = Offset(position.dx, temp - imageSize.y / 1.5);
//      shieldDetails.shieldPosition = shieldPos;
        double shieldRadius = gameController.tileSize;
        shieldPaint = new Paint();
        shieldPaint..isAntiAlias = true;
        shieldPaint
          ..color = (shieldDetails.color).withAlpha(
              ((shieldDetails.curHealth / shieldDetails.maxHealth) * 255)
                  .toInt());
        shieldPaint..style = PaintingStyle.stroke;
        shieldPaint..strokeWidth = ((gameController.tileSize) / 2.5);

        shieldPaint
          ..shader = RadialGradient(colors: [
            Colors.white,
            shieldDetails.color.withOpacity(0.25),
          ], tileMode: TileMode.mirror)
              .createShader(Rect.fromCircle(
            center: shieldPos,
            radius: gameController.tileSize * 0.7,
          ));
        canvas.drawCircle(shieldPos, shieldRadius, shieldPaint);
      }

      if (shieldDetails == null) {
        tankPath = tank.shift(Offset(position.dx, temp));
      } else {
        tankPath = Path();
        Offset shieldPos = Offset(position.dx, temp - imageSize.y / 1.5);
        double shieldRadius =
            gameController.tileSize + (gameController.tileSize) / 5;
        Rect rect = Rect.fromCircle(center: shieldPos, radius: shieldRadius);
        tankPath.addOval(rect);
      }
    } else if (explosion != null) {
//      explosion.render(canvas);
    }
  }

  void update(double t) {
    if (alive) {
      if (position.dy != gameController.mountain.points[position.dx.toInt()].dy)
        position = Offset(position.dx,
            gameController.mountain.points[position.dx.toInt()].dy);
    } else if (explosion != null) {
      explosion.update(t);
    }
  }

  static double degreeToRadian(double degree) {
    return degree * 3.14 / 180;
  }

  bool contain(Offset pos) {
    if (gameController.tank == this) {
      return false;
    } else
      return tankPath.contains(pos);
  }

  void damageDealt(double damage) {
    if (gameController.tank != this) {
      gameController.tank.score += damage * 100;
      gameController.tank.totalScore += damage * 100;
    } else {
      damage *= 0.1;
      score -= damage * 100;
      totalScore -= damage * 100;
    }
    if (shieldDetails != null) {
      shieldDetails.curHealth -= damage / tankPower.shieldPower;
      if (shieldDetails.curHealth <= 0) {
        damage = shieldDetails.curHealth.abs();
        shieldDetails = null;
      } else {
        damage = 0;
      }
    }
    health -= damage;
    if (health <= 0) {
      alive = false;
      gameController.alivePlayer--;
    }
  }

  static Future loadTanks() async {
    List<String> colors = [
      "amber",
      "blue",
      "green",
      "brown",
      "yellow",
      "pink",
      "aquamarine",
      "lightGreen",
      "darkkaki",
      "tan",
    ];
    var futures = colors.map((e) => Flame.images.load('$e.png'));
    List list = await Future.wait(futures);
    for(int i=0;i<colors.length;i++) {
      _loadedTanks[colors[i]] = list[i];
    }
    return;
  }

  static Map<String, Image> _loadedTanks = {};

  //Add for robot
  Offset get tankCenter => Offset(position.dx, temp - imageSize.y);
}
