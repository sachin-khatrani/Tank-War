import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/models/tankModel.dart';
import 'package:tankwar/screens/Online_Mode/start_game_online.dart';

class PlayerWaiting extends StatefulWidget {
  final String roomId;
  final Size size;
  final Size playSize = Size(900,300);
  final SharedPreferences sharedPreferences;
  List<TankModel> allTanks;
  List<String> availableTanks = [
    "amber",
    "blue",
    "green",
    "brown",
    "yellow",
    "pink",
    "aquamarine",
    "lightGreen",
    "darkkaki",
    "tan",
  ];

  PlayerWaiting({Key key, this.roomId, this.size, this.sharedPreferences})
      : super(key: key);

  @override
  _PlayerWaitingState createState() => _PlayerWaitingState();
}

class _PlayerWaitingState extends State<PlayerWaiting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.allTanks = new List();
    startTimer();
    readyPlayer();
  }

  startTimer() async {
    return new Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StartGameOnline(
                    roomId: widget.roomId,
                    size: widget.size,
                    allTanks: widget.allTanks,
                    sharedPreferences: widget.sharedPreferences,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.brown[100],
        height: 50,
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(child: Image.asset("assets/images/tank.gif",height: 50,width: 50,), ),
          ],
        ),
      ),
    );
  }

  Future<void> readyPlayer() async {
    CollectionReference roomCollection = Firestore.instance.collection('room');

    // generate seed..
    int seed = 0;
    widget.roomId.codeUnits.forEach((val) => seed += val);
    print(seed);

    Random r = new Random(seed);

    Map<String, dynamic> roomData = await roomCollection
        .document(widget.roomId)
        .get()
        .then((value) => value.data);
    List userIds = roomData.keys.toList();
    userIds.remove("isWaiting");
    userIds.remove("number");
    userIds.remove("time");
    userIds.remove("");

    int n = userIds.length;
    // TODO: Random sorting
    userIds.sort();
    int curSize = widget.playSize.width ~/ n;
    int ind = r.nextInt(10);

    // TODO: gameController ma a calculation karvu ......
    int tileSize = 900 ~/ 34;
    for (int i = 0; i < n; i++) {
      TankModel tank = new TankModel();
      tank.uid = userIds[i];
      tank.color = widget.availableTanks[ind]; // Give Color by index..
      ind = (ind + 1) % 10;
      if (i % 2 == 0) {
        int pos;
        if (i == 0) {
          pos = r.nextInt(curSize) + curSize * i + tileSize + 1;
        } else {
          pos = r.nextInt(curSize) + curSize * i;
        }
        tank.pos = pos;
//        tank.pos = gameController.mountain.points[pos];
      } else {
        int pos;
        if (i == 1) {
          pos = r.nextInt(curSize) + curSize * (n - i) - tileSize - 1;
        } else {
          pos = r.nextInt(curSize) + curSize * (n - i);
        }
        tank.pos = pos;
//        tank.pos = gameController.mountain.points[pos];
      }
      widget.allTanks.add(tank);
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    await roomCollection
        .document(widget.roomId)
        .updateData({"$uid": "waiting"});

    for (int i = 0; i < n; i++) {
      print(
          "${widget.allTanks[i].uid} ${widget.allTanks[i].color} ${widget.allTanks[i].pos}");
    }
  }
}
