import 'package:flutter/material.dart';
import 'package:tankwar/Shield/shield.dart';

class NormalShield extends ShieldDetails{
  NormalShield() {
    super.index = 2;
    super.maxHealth = 200;
    super.color = Colors.blue;
    super.curHealth = maxHealth;
//    super.shieldPosition = shieldPosition;
  }
}