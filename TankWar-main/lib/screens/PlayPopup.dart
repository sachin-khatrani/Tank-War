import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/screens/Online_Mode/LoadingScreen.dart';
import 'package:tankwar/screens/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/screens/player_selection.dart';

class PlayPopUp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  const PlayPopUp({Key key, this.sharedPreferences, this.size})
      : super(key: key);

  @override
  _PlayPopUpState createState() => _PlayPopUpState();
}

class _PlayPopUpState extends State<PlayPopUp>
    with SingleTickerProviderStateMixin {
  bool offline = true;
  double tileSize;

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    tileSize = MediaQuery.of(context).size.width / 50;
    return Opacity(
      opacity: _animation.value,
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 0.6,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (!offline)
                          setState(() {
                            offline = true;
                          });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                          'Offline',
                          style: TextStyle(
                              fontSize: tileSize * 1.5,
                              fontFamily: 'Capture_it'),
                        )),
                        decoration: BoxDecoration(
                            color: offline
                                ? Colors.brown.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(tileSize * 2),
                                topRight: Radius.circular(tileSize * 2))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (offline)
                          setState(() {
                            offline = false;
                          });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                          'Online',
                          style: TextStyle(
                              fontSize: tileSize * 1.5,
                              fontFamily: 'Capture_it'),
                        )),
                        decoration: BoxDecoration(
                            color: !offline
                                ? Colors.brown.withOpacity(0.5)
                                : Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(tileSize * 2),
                                topRight: Radius.circular(tileSize * 2))),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(tileSize),
                        bottomRight: Radius.circular(tileSize)),
//                  border: Border.all(width: 1)
                  ),
                  child: Center(
                    child: offline
                        ? OfflineMenu(
                            sharedPreferences: widget.sharedPreferences,
                            size: widget.size,
                          )
                        : OnlineMenu(
                            sharedPreferences: widget.sharedPreferences,
                            size: widget.size,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineMenu extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  OfflineMenu({Key key, this.sharedPreferences, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FancyButton(
            child: Container(
              child: Center(
                child: Text(
                  'New Game',
                  style: TextStyle(fontFamily: 'Capture_it'),
                ),
              ),
              width: MediaQuery.of(context).size.width / 6.5,
            ),
            color: Colors.brown,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlayerSelection(
                            size: size,
                            sharedPreferences: sharedPreferences,
                          )));
            },
            size: MediaQuery.of(context).size.width / 10,
            duration: Duration(milliseconds: 200)),
        FancyButton(
            child: Container(
              child: Center(
                child: Text('Load Game',
                    style: TextStyle(fontFamily: 'Capture_it')),
              ),
              width: MediaQuery.of(context).size.width / 6.5,
            ),
            color: Colors.brown,
            onPressed: () {},
            size: MediaQuery.of(context).size.width / 10,
            duration: Duration(milliseconds: 200)),
      ],
    );
  }
}

class OnlineMenu extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  OnlineMenu({Key key, this.size, this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FancyButton(
            child: Container(
              child: Center(
                child: Text(
                  'Random',
                  style: TextStyle(fontFamily: 'Capture_it'),
                ),
              ),
              width: MediaQuery.of(context).size.width / 6.5,
            ),
            color: Colors.brown,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                            size: size,
                            message: "Match",
                            isRandom: true,
                            sharedPreferences: sharedPreferences,
                          )));
            },
            size: MediaQuery.of(context).size.width / 10,
            duration: Duration(milliseconds: 200)),
        FancyButton(
            child: Container(
              child: Center(
                  child: Text('Friendly',
                      style: TextStyle(fontFamily: 'Capture_it'))),
              width: MediaQuery.of(context).size.width / 6.5,
            ),
            color: Colors.brown,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                            size: size,
                            message: "Match",
                            isRandom: false,
                            sharedPreferences: sharedPreferences,
                          )));
            },
            size: MediaQuery.of(context).size.width / 10,
            duration: Duration(milliseconds: 200))
      ],
    );
  }
}
