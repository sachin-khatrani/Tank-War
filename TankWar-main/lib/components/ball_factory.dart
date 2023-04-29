import 'package:flutter/cupertino.dart';
import 'package:tankwar/components/fire_details.dart';
import 'package:tankwar/components/fireball/Ball.dart';
import 'package:tankwar/components/fireball/Jump_Bomb.dart';
import 'package:tankwar/components/fireball/crackers_bomb.dart';
import 'package:tankwar/components/fireball/fire_ball.dart';
import 'package:tankwar/components/fireball/tank_jump.dart';
import 'package:tankwar/game_controller.dart';

import 'fireball/electric_ball.dart';
import 'fireball/fuse_ball.dart';
import 'fireball/large_ball_v1.dart';
import 'fireball/volcano_bomb.dart';

class BallFactory {
  static Ball getBall({String name, GameController gameController, FireDetails fireDetails, Offset initialPosition}) {
    Ball fireBall;
    switch(name) {
      case 'Fire Ball':
        fireBall = FireBall(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'Fuse Ball':
        fireBall = FuseBall(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'Large Ball':
        fireBall = LargeBall(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'Volcano Bomb':
        fireBall = VolcanoBomb(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'Electric Bomb':
        fireBall = ElectricBall(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'Cracker Ball':
        fireBall = CrackersBomb(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'Jump Ball':
        fireBall = JumpBomb(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
      case 'TankJump Ball':
        fireBall = TankJump(gameController: gameController, fireDetails: fireDetails, initialPosition: initialPosition);
        break;
    }

    return fireBall;
  }
}