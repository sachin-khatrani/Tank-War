import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tankwar/components/game_status.dart';
import 'package:tankwar/screens/main_screen.dart';
import 'package:tankwar/screens/play_screen.dart';
import 'package:tankwar/screens/support_selection.dart';
import 'package:tankwar/screens/weapon_selection.dart';
import 'package:tankwar/screens/weapon_support.dart';

import '../game_controller.dart';
class ScreenController extends StatefulWidget {
  final GameController gameController;
  int index;
  ScreenController({this.gameController}) {
    index = 0;
  }

  @override
  _ScreenControllerState createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {


  @override
  void initState() {
    super.initState();
    widget.gameController.updateGameState = updateState;
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Container(
      color: Colors.blue,
      child: getWidget(),
    );

  }

  Widget getWidget() {
    Widget myWidget;
    Status gameStatus = widget.gameController.gameStatus;
    print("$gameStatus-");

    if(gameStatus == Status.playing) {
      myWidget = PlayScreen(gameController: widget.gameController,updateState: updateState,);
    }
    else if(gameStatus == Status.starting) {
      myWidget = AnimationCircle(
          gameController: widget.gameController, updateState: updateState);
    }
    else if(gameStatus == Status.roundOver) {
      myWidget = WeaponSupport(gameController: widget.gameController,
        updateState: updateState,
        curPlayer: widget.index,);
    }
    else if(gameStatus == Status.gameOver) {
      // make game over

    }
    else if(gameStatus == Status.weapon) {
      myWidget = WeaponSelection(
        gameController: widget.gameController,
        updateState: updateState,
        previousWeapons: widget.gameController.tanks[widget.index].accessories.weapons,
        playerInd: widget.index,
      );
    } else if(gameStatus == Status.support) {
      myWidget = SupportSelection(
        gameController: widget.gameController,
        updateState: updateState,
        playerInd: widget.index,
      );
    }

    return myWidget;
  }

  void updateState({int ind = -1}) {
    setState(() {
      if(ind != -1) {
        widget.index++;
        if(widget.index >= widget.gameController.noOfPlayer)
          widget.index = 0;
      }
    });
  }

}
