import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game_controller.dart';
import 'fire_details.dart';

class FireBall {
  final GameController gameController;
  Offset initialPosition;
  Offset position;
  Paint paint;
  Rect rect;
  double radius;
  double powerFactor;
  FireDetails fireDetails = FireDetails(firePosition: Offset.zero, angle: 0.0, power: 0.0);
  double time;

  FireBall({this.gameController, this.initialPosition, this.fireDetails}) {
    position = initialPosition;
    paint = Paint()..color = Colors.white;
    radius = 5;
    time = 0.0;

  }

  void render(Canvas canvas) {
    rect = Rect.fromCenter(center: position, width: radius, height: radius);
    canvas.drawOval(rect, paint);

  }

  void update(double t) {
    updatePosition(t);
    try{
      if(position.dx <= 0 && position.dx >= gameController.mountain.points.length
          || position.dy >= gameController.playScreenSize.height
          || position.dy >= gameController.mountain.points[position.dx.toInt()].dy)  {

        gameController.fired = false;
        position = (Offset(-10.0,-10.0));


      }  else {
        updatePosition(t);
      }
    } catch(e) {
      gameController.fired = false;
      position = (Offset(-10.0,-10.0));
    }



  }

  void updatePosition(double t) {
    time += 0.03;
    powerFactor = 0.8;
    double dx = initialPosition.dx + powerFactor *  fireDetails.power * cos(fireDetails.angle) * time + 0.04 * gameController.wind.windPower * time * time;
    double dy = initialPosition.dy - powerFactor * fireDetails.power * sin(fireDetails.angle) * time  +  0.5 * gameController.wind.gravity * time * time;

    position = Offset(dx, dy);

//    position = Offset(dx, gameController.playScreenSize.height - dy);
  }

}

/*
|| position.dy >= gameController.points[position.dx.toInt()].dy
 */