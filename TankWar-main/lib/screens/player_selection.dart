import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/models/player.dart';
import 'package:tankwar/screens/add_player_dialog.dart';
import 'package:tankwar/screens/start_game_offline.dart';

class PlayerSelection extends StatefulWidget {
  List<Player> allPlayers = new List();
  double tileSize;
  final SharedPreferences sharedPreferences;
  final Size size;
  final String mode = "Offline";
  List<MaterialColor> availableTanks = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
    Colors.yellow,
    Colors.pink,
    Colors.lightGreen,
  ];

  PlayerSelection({Key key, this.sharedPreferences, this.size})
      : super(key: key);

  @override
  _PlayerSelectionState createState() => _PlayerSelectionState();
}

class _PlayerSelectionState extends State<PlayerSelection> {
  @override
  Widget build(BuildContext context) {
    widget.tileSize = MediaQuery.of(context).size.width / 22.5;
    int n = widget.allPlayers.length;
    Widget firstPlayer, secondPlayer, thirdPlayer;
    Widget forthPlayer, fifthPlayer, sixthPlayer;

    firstPlayer = (n >= 1) ? getProfile(0) : getEmptyProfile();
    secondPlayer = (n >= 2) ? getProfile(1) : getEmptyProfile();
    thirdPlayer = (n >= 3) ? getProfile(2) : getEmptyProfile();
    forthPlayer = (n >= 4) ? getProfile(3) : getEmptyProfile();
    fifthPlayer = (n >= 5) ? getProfile(4) : getEmptyProfile();
    sixthPlayer = (n >= 6) ? getProfile(5) : getEmptyProfile();

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () async => false,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              height: constraints.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      firstPlayer,
                      secondPlayer,
                      thirdPlayer,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlatButton(
                              color: Colors.grey,
                              child: Text("Add Player"),
                              onPressed: (widget.allPlayers.length >= 6)
                                  ? null
                                  : () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => AddPlayerDialog(
                                                tileSize: widget.tileSize,
                                                availableTanks:
                                                    widget.availableTanks,
                                                addPlayer: addPlayer,
                                              ));
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Second Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            FlatButton(
                              color: Colors.grey,
                              child: Text("Start Game"),
                              onPressed: (widget.allPlayers.length <= 1)
                                  ? null
                                  : () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StartGameOffline(
                                                    size: widget.size,
                                                    allPlayer:
                                                        widget.allPlayers,
                                                    mode: widget.mode,
                                                    sharedPreferences: widget
                                                        .sharedPreferences,
                                                  )));
                                    },
                            ),
                            FlatButton(
                              color: Colors.grey,
                              child: Text("Exit Lobby"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      forthPlayer,
                      fifthPlayer,
                      sixthPlayer,
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getEmptyProfile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.tileSize * 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(width: 5.0, color: Colors.blueGrey),
            ),
            height: widget.tileSize * 3.3,
            width: widget.tileSize * 3.3,
          ),
          SizedBox(
            height: widget.tileSize * 0.25,
          ),
          Container(
            child: Text(
              " ",
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget getProfile(int i) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.tileSize * 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: widget.tileSize * 3.8,
                width: widget.tileSize * 3.8,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/${widget.allPlayers[i].color}.png'),
                      ),
                      border: Border.all(width: 5.0, color: Colors.blueGrey),
                    ),
                    height: widget.tileSize * 3.3,
                    width: widget.tileSize * 3.3,
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  width: widget.tileSize * 0.8,
                  height: widget.tileSize * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      'X',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  String color = widget.allPlayers[i].color;
                  widget.allPlayers.removeAt(i);
                  if (color == "amber") {
                    widget.availableTanks.add(Colors.amber);
                  } else if (color == "blue") {
                    widget.availableTanks.add(Colors.blue);
                  } else if (color == "green") {
                    widget.availableTanks.add(Colors.green);
                  } else if (color == "brown") {
                    widget.availableTanks.add(Colors.brown);
                  } else if (color == "yellow") {
                    widget.availableTanks.add(Colors.yellow);
                  } else if (color == "pink") {
                    widget.availableTanks.add(Colors.pink);
                  } else if (color == "lightGreen") {
                    widget.availableTanks.add(Colors.lightGreen);
                  }

                  updateState();
                },
              )
            ],
          ),
          Container(
            child: Text(widget.allPlayers[i].name),
          ),
        ],
      ),
    );
  }

  void updateState() {
    setState(() {});
  }

  void addPlayer(String name, String color, bool isBot) {
    if (color == "amber") {
      widget.availableTanks.remove(Colors.amber);
    } else if (color == "blue") {
      widget.availableTanks.remove(Colors.blue);
    } else if (color == "green") {
      widget.availableTanks.remove(Colors.green);
    } else if (color == "brown") {
      widget.availableTanks.remove(Colors.brown);
    } else if (color == "yellow") {
      widget.availableTanks.remove(Colors.yellow);
    } else if (color == "pink") {
      widget.availableTanks.remove(Colors.pink);
    } else if (color == "lightGreen") {
      widget.availableTanks.remove(Colors.lightGreen);
    }

    widget.allPlayers.add(new Player(
      color: color,
      name: name,
      level: 1,
      isBot: isBot,
    ));
    updateState();
  }
}
