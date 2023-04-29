import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/game_controller.dart';
import 'package:tankwar/models/tankModel.dart';
import 'package:tankwar/screens/exitPopup.dart';
import 'package:tankwar/screens/screen_controller.dart';

class StartGameOnline extends StatefulWidget {
  final String roomId;
  final List<TankModel> allTanks;
  final SharedPreferences sharedPreferences;
  final Size size;
  bool isExit = false;

  StartGameOnline(
      {Key key, this.roomId, this.allTanks, this.sharedPreferences, this.size})
      : super(key: key);

  @override
  _StartGameOnlineState createState() => _StartGameOnlineState();
}

class _StartGameOnlineState extends State<StartGameOnline> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPlayers();
  }

  GameController gameController;

  void setExit(bool e) {
    widget.isExit = e;
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    await showDialog(
      context: context,
      child: ExitPopUp(setExit: setExit,),
      barrierDismissible: false,
    );
    return widget.isExit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: _willPopCallback,
          child: ScreenController(
            gameController: gameController,
          )),
    );
  }

  void loadPlayers() {
    print('size -----> ${widget.size}');
    gameController = new GameController(
        widget.sharedPreferences, widget.size, "Online",
        allTanks: widget.allTanks, roomId: widget.roomId);
  }
}
