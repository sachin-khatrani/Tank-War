import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/Controllers/control_controller.dart';
import 'package:tankwar/components/score.dart';
import 'package:tankwar/components/wind_display.dart';
import 'package:tankwar/game_controller.dart';
import 'package:zoom_widget/zoom_widget.dart';

class PlayScreen extends StatelessWidget {
  final GameController gameController;
  final Function updateState;

  const PlayScreen({Key key, this.gameController, this.updateState})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    print(gameController.tanks[gameController.turn].isBot);
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Zoom(
                  width: gameController.playScreenSize.width,
                  height: gameController.playScreenSize.height,
                  backgroundColor: Colors.blue,
                  scrollWeight: 0.0,
                  initZoom: 0.5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: gameController.playScreenSize.height,
                    child: gameController.widget,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: WindDisplay(
                  gameController: gameController,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ScoreDisplay(
                  gameController: gameController,
                ),
              )
            ],
          ),
          Expanded(
              child: Container(
            width: MediaQuery.of(context).size.width,
//                height: gameController.screenSize.height*(0.20),
            child: Stack(
              children: [
                ControllerMenu(gameController),
                if(gameController.tanks[gameController.turn].isBot) Container(
                  color: Colors.grey.withOpacity(0.5),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
