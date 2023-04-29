import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/Controllers/controller_status.dart';
import 'package:tankwar/Shield/SuperShield.dart';
import 'package:tankwar/Shield/normalShield.dart';
import 'package:tankwar/Shield/strongShield.dart';
import 'package:tankwar/Shield/weakShield.dart';
import 'package:tankwar/game_controller.dart';

class ConfirmController extends StatefulWidget {
  final GameController gameController;
  final Function updateState;
//  final ControllerStatus controllerStatus;

  ConfirmController({this.gameController, this.updateState});
  @override
  _ConfirmControllerState createState() => _ConfirmControllerState();
}

class _ConfirmControllerState extends State<ConfirmController> {
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          getPanelMessage(),

          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.6,
            child: Container(
              height: (widget.gameController.screenSize.height*0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                child: Image.asset('assets/images/confirm.png'),
                onPressed: () {
                  confirmChange();
                  widget.updateState();
                },
                color: Colors.white,
                splashColor: Colors.blue[100],
                elevation: widget.gameController.controllerTileSize / 2.5,
                highlightElevation: widget.gameController.controllerTileSize / 12.5,
                animationDuration: Duration(milliseconds: 1000),
                shape: CircleBorder(),
              ),
            ),
          ),


          ButtonTheme(
            minWidth: widget.gameController.controllerTileSize * 1.6,
            child: Container(
              height: (widget.gameController.screenSize.height*0.15),
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                child: Image.asset('assets/images/reject.png'),
                onPressed: () {
                  rejectChange();
                  widget.updateState();
                },
                color: Colors.white,
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

  void confirmChange() {
    if(widget.gameController.prevControllerStatus == ControllerStatus.move) {
      widget.gameController.isTeleport = false;
      widget.gameController.controllerStatus = widget.gameController.prevControllerStatus;
      if(widget.gameController.teleportPosition != null) {
        widget.gameController.gameMode.teleportPosition(
          widget.gameController.teleportPosition,
        );
      }
      widget.gameController.tank.accessories.teleport--;
      widget.gameController.teleportPosition = null;
    } else if(widget.gameController.prevControllerStatus == ControllerStatus.buff) {
      if(widget.gameController.isShieldSelection == true) {
        widget.gameController.controllerStatus =
            widget.gameController.prevControllerStatus;
        widget.gameController.isShieldSelection = false;
        if(widget.gameController.tank.shieldDetails is WeakShield)
            widget.gameController.tank.accessories.weakShield--;
        else if(widget.gameController.tank.shieldDetails is NormalShield)
          widget.gameController.tank.accessories.normalShield--;
        else if(widget.gameController.tank.shieldDetails is StrongShield)
          widget.gameController.tank.accessories.strongShield--;
        else if(widget.gameController.tank.shieldDetails is SuperShield)
          widget.gameController.tank.accessories.superShield--;
      } else {
        widget.gameController.controllerStatus =
            widget.gameController.prevControllerStatus;
        widget.gameController.tank.shieldDetails = null;
      }
    }
  }

  void rejectChange() {
    if(widget.gameController.prevControllerStatus == ControllerStatus.move) {
      widget.gameController.isTeleport = false;
      widget.gameController.controllerStatus =
          widget.gameController.prevControllerStatus;
      widget.gameController.teleportPosition = null;
    } else if(widget.gameController.prevControllerStatus == ControllerStatus.buff) {
      if(widget.gameController.isShieldSelection == true) {
        widget.gameController.tank.shieldDetails = null;
        widget.gameController.controllerStatus =
            widget.gameController.prevControllerStatus;
        widget.gameController.isShieldSelection = false;
      } else {
        widget.gameController.controllerStatus =
            widget.gameController.prevControllerStatus;
      }
    }
  }

  Widget getPanelMessage() {
    if(widget.gameController.prevControllerStatus == ControllerStatus.move) {
      return Text(
        'Are you sure for Teleport ?',
        style: TextStyle(
          fontSize: widget.gameController.controllerTileSize * 0.75,
          fontWeight: FontWeight.bold,
          color: Colors.amberAccent,
        ),
      );
    } else if(widget.gameController.prevControllerStatus == ControllerStatus.buff) {
      if(widget.gameController.isShieldSelection == true) {
        return Text(
          'Are you sure to apply this shield ?',
          style: TextStyle(
            fontSize: widget.gameController.controllerTileSize * 0.75,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        );
      } else {
        return Text(
          'Are you sure to remove current shield ?',
          style: TextStyle(
            fontSize: widget.gameController.controllerTileSize * 0.75,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        );
      }
    } else {
      return Container();
    }
  }

}
