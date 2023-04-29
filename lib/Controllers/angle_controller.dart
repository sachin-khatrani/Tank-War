import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/Controllers/controller_status.dart';
import 'package:tankwar/game_controller.dart';

class AngleController extends StatefulWidget {
  final GameController gameController;
  final Function updateState;

  AngleController({this.gameController, this.updateState});
  @override
  _AngleControllerState createState() => _AngleControllerState();
}

class _AngleControllerState extends State<AngleController> {
  bool buttonPressed = false;

  void updateAngle(double angle) {
    setState(() {});
    widget.gameController.tank.fireDetails.angle = (angle * 3.14 / 180);
  }

  void increaseAngle() async {
    while (buttonPressed) {
      if(widget.gameController.tank.fireDetails.angle < 180) {
        widget.gameController.gameMode.increaseAngle();
        setState(() {});
        await Future.delayed(Duration(milliseconds: 50));
      }
    }
  }

  void decreaseAngle() async {
    while (buttonPressed) {
      if(widget.gameController.tank.fireDetails.angle > 0) {
        widget.gameController.gameMode.decreaseAngle();
        setState(() {});
        await Future.delayed(Duration(milliseconds: 50));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white30,
            Colors.grey[800],
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
//          SizedBox(
//            width: widget.gameController.controllerTileSize,
//          ),
          Text(
            'Angle Panel',
            style: TextStyle(
              fontSize: widget.gameController.controllerTileSize * 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            ),
          ),

          getAngleSlider(),
          // Minus Button
          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              child: RaisedButton(
                padding: EdgeInsets.all(widget.gameController.controllerTileSize / 5),
                child: Listener(
                  onPointerDown: (details) {
                    buttonPressed = true;
                    decreaseAngle();
                  },
                  onPointerUp: (details) {
                    buttonPressed = false;
                  },
                  child: Text(
                    '-',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.gameController.controllerTileSize,
                    ),
                  ),
                ),
                onPressed: () {},
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(widget.gameController.controllerTileSize*0.48,
                      widget.gameController.controllerTileSize*0.2)),
                ),
              ),
            ),
          ),

//          SizedBox(
//            width: 10,
//          ),

          Text(
            (widget.gameController.tank.fireDetails.angle * 180 ~/ 3.14).toString(),
            style: TextStyle(
              color: Colors.grey[350],
              fontWeight: FontWeight.bold,
              fontSize: widget.gameController.controllerTileSize * 0.8,
            ),
          ),

//          SizedBox(
//            width: 10,
//          ),
          // Plus Button
          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              child: RaisedButton(
                padding: EdgeInsets.all(widget.gameController.controllerTileSize / 5),
                child: Listener(
                  onPointerDown: (details) {
                    buttonPressed = true;
                    increaseAngle();
                  },
                  onPointerUp: (details) {
                    buttonPressed = false;
                  },
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.gameController.controllerTileSize,
                    ),
                  ),
                ),
                onPressed: () {},
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(widget.gameController.controllerTileSize*0.48,
                      widget.gameController.controllerTileSize*0.2)),
                ),
              ),
            ),
          ),

//          Expanded(
//            child: SizedBox(
//              width: 70,
//            ),
//          ),

          // Ok button
          ButtonTheme(
            child: Container(
              child: RaisedButton(
                padding: EdgeInsets.all(widget.gameController.controllerTileSize / 2.5),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: widget.gameController.controllerTileSize,
                  ),
                ),
                onPressed: () {
                  widget.gameController.controllerStatus = ControllerStatus.main;
                  print('return to main controller');
                  widget.updateState();
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                shape: CircleBorder(),
              ),
            ),
          ),
//          SizedBox(
//            width: 50,
//          ),
        ],
      ),
    );
  }

  Widget getAngleSlider() {
    return Container(
      child: Slider(
        activeColor: Colors.blue,
        inactiveColor: Colors.blue[100],
        value: (widget.gameController.tank.fireDetails.angle * 180 ~/ 3.14).toDouble(),
        label: (widget.gameController.tank.fireDetails.angle * 180 ~/ 3.14).toString(),
        min: 0,
        max: 180,
//        divisions: 360,
        onChanged: (double value) {
          updateAngle(value);
        },
      ),
    );
  }
}
