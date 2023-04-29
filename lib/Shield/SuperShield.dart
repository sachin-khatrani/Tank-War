import 'package:flutter/material.dart';
import 'package:tankwar/Shield/shield.dart';

class SuperShield extends ShieldDetails{
  SuperShield() {
    super.index = 4;
    super.maxHealth = 400;
    super.color = Colors.redAccent;
    super.curHealth = maxHealth;
//    super.shieldPosition = shieldPosition;
  }
}