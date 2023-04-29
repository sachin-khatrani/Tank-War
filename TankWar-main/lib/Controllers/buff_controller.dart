import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/Controllers/controller_status.dart';
import 'package:tankwar/game_controller.dart';

class BuffController extends StatefulWidget {
  final GameController gameController;
  final Function updateState;

  BuffController({this.gameController, this.updateState});

  @override
  _BuffControllerState createState() => _BuffControllerState();
}

class _BuffControllerState extends State<BuffController> {
  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              height: (widget.gameController.screenSize.height * 0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/repair-kit.png'),
                      width: widget.gameController.controllerTileSize * 1.25,
                      height: widget.gameController.controllerTileSize * 1.25,
                    ),
                    Text(
                        widget.gameController.tank.accessories.repairKit
                            .toString(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: widget.gameController.controllerTileSize / 1.5,
                        )),
                  ],
                ),
                onPressed: () {
                  widget.gameController.gameMode
                      .increaseHealth(updateHealthState);
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      widget.gameController.controllerTileSize * 0.48,
                      widget.gameController.controllerTileSize * 0.2)),
                ),
              ),
            ),
          ),

          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              height: (widget.gameController.screenSize.height * 0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/weak.png'),
                    ),
                    Text(
                        widget.gameController.tank.accessories.weakShield
                            .toString(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: widget.gameController.controllerTileSize / 1.5,
                        )),
                  ],
                ),
                onPressed: () {
                  widget.gameController.gameMode
                      .applyShield(1, widget.updateState);
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      widget.gameController.controllerTileSize * 0.48,
                      widget.gameController.controllerTileSize * 0.2)),
                ),
              ),
            ),
          ),
//          SizedBox(width: 50.0,),
          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              height: (widget.gameController.screenSize.height * 0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(1),
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/normal.png'),
                    ),
                    Text(
                        widget.gameController.tank.accessories.normalShield
                            .toString(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: widget.gameController.controllerTileSize / 1.5,
                        )),
                  ],
                ),
                onPressed: () {
                  widget.gameController.gameMode
                      .applyShield(2, widget.updateState);
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      widget.gameController.controllerTileSize * 0.48,
                      widget.gameController.controllerTileSize * 0.2)),
                ),
              ),
            ),
          ),
//          SizedBox(width: 50.0,),
          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              height: (widget.gameController.screenSize.height * 0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(widget.gameController.controllerTileSize / 10.0),
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/strong.png'),
                    ),
                    Text(
                        widget.gameController.tank.accessories.strongShield
                            .toString(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: widget.gameController.controllerTileSize / 1.5,
                        )),
                  ],
                ),
                onPressed: () {
                  widget.gameController.gameMode
                      .applyShield(3, widget.updateState);
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      widget.gameController.controllerTileSize * 0.48,
                      widget.gameController.controllerTileSize * 0.2)),
                ),
              ),
            ),
          ),

          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.8,
            child: Container(
              height: (widget.gameController.screenSize.height * 0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(widget.gameController.controllerTileSize / 10.0),
                child: new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/super.png'),
                    ),
                    Text(
                        widget.gameController.tank.accessories.superShield
                            .toString(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: widget.gameController.controllerTileSize / 1.5,
                        )),
                  ],
                ),
                onPressed: () {
                  widget.gameController.gameMode
                      .applyShield(4, widget.updateState);
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      widget.gameController.controllerTileSize * 0.48,
                      widget.gameController.controllerTileSize * 0.2)),
                ),
              ),
            ),
          ),
//          SizedBox(width: 50.0,),

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
                  widget.gameController.controllerStatus =
                      ControllerStatus.main;
                  print('return to main controller');
                  widget.updateState();
                },
                color: Colors.blue,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateHealthState() {
    setState(() {
      widget.gameController.tank.health += 10;
      widget.gameController.tank.accessories.repairKit--;
    });
  }
}
