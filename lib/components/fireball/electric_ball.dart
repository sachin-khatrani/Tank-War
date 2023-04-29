import 'dart:ui';

import 'package:tankwar/components/fireball/fire_ball.dart';

import '../explosion.dart';
import 'dart:math';
class ElectricBall extends FireBall {
  List<Explosion> secondExplosions;
  final _random = new Random();
  ElectricBall({gameController, initialPosition, fireDetails}) : super(gameController: gameController,initialPosition: initialPosition, fireDetails: fireDetails) {
    name = "Electric Bomb";
  }
  void setExplode() {
    print('Set explode was called');
    exploded = true;
    explosion = Explosion(gameController: gameController, position: position, radius: 30, function: () {}, );
    secondExplosions = List<Explosion>();



    secondExplosions.add(Explosion(
        gameController: gameController,
        position: position - Offset(-(explosion.radius)/ 2 - next(15, 35),(explosion.radius) / 2 - next(15, 25)),
        radius: 20,
        damageFactor: 0.5 * explosion.damageFactor,
        function: () {}));

    secondExplosions.add(Explosion(
        gameController: gameController,
        position: position + Offset(-(explosion.radius)/ 2  - next(15, 30),(explosion.radius) / 2 - next(0, 13) ),
        radius: 20,
        damageFactor: 0.5 * explosion.damageFactor,
        function: () {}));

    secondExplosions.add(Explosion(
        gameController: gameController,
        position: position + Offset(-(explosion.radius)/ 2 - next(1, 10),(explosion.radius) / 2 - next(8, 15)),
        radius: 20,
        damageFactor: 0.5 * explosion.damageFactor,
        function: () {}));

    secondExplosions.add(Explosion(
        gameController: gameController,
        position: position - Offset(-(explosion.radius)/ 2 - next(1, 10),(explosion.radius) / 2 - next(8, 15)),
        damageFactor: 0.5 * explosion.damageFactor,
        radius: 20,
        function: () {
          this.exploded = false;
          gameController.gameMode.nextTurn();
          gameController.fired = false;
          gameController.fireBall.position = Offset(-10, -10);
        }));
  }

  void renderExplosion(Canvas canvas) {
   explosion.render(canvas);
    if (explosion.flag && secondExplosions != null) {
      secondExplosions[0].render(canvas);
      secondExplosions[1].render(canvas);
      secondExplosions[2].render(canvas);
      secondExplosions[3].render(canvas);
    }

  }

  int next(int min, int max) {
    return gameController.gameMode.next(min, max);
  }

  void updateExplosion(double t) {
    explosion.update(t);
    if (explosion.flag && secondExplosions != null) {
      secondExplosions.forEach((Explosion explosion) {
        explosion.update(t);
      });
    }
  }
}

