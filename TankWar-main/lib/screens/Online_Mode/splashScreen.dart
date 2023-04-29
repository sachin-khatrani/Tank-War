import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/models/player.dart';
import 'package:tankwar/screens/Online_Mode/hex_lobby.dart';
import 'package:tankwar/screens/Online_Mode/player_waiting.dart';

class SplashScreen extends StatefulWidget {
  String roomId;
  final bool isRandom;
  final Size size;
  dynamic listener;
  final SharedPreferences sharedPreferences;

  SplashScreen({this.roomId, this.isRandom, this.size, this.sharedPreferences});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState called');
    players.clear();
    addMatchingListener(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = MediaQuery.of(context).size.width / 22.5;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: OnlineLobby(
            tileSize: tileSize,
            roomId: widget.roomId,
            isRandom: widget.isRandom,
          ),
        ),
      ),
    );
  }

  void addMatchingListener(String roomId) {
    CollectionReference roomCollection = Firestore.instance.collection('room');
    widget.listener =
        roomCollection.document(roomId).snapshots().listen((querySnapshot) {
      Map data = querySnapshot.data;
      print(data);
      updateList(data);
      if (data['isWaiting'] != "false" && data['isWaiting'] != "true") {
        roomId = data['isWaiting'];
        removeMatchingListener(widget.listener);
        changeMatchingListener(roomId);
      }
      if (data['isWaiting'] == "false") {
        print('Lobby Created');
        removeMatchingListener(widget.listener);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerWaiting(
                      roomId: widget.roomId,
                      size: widget.size,
                      sharedPreferences: widget.sharedPreferences,
                    )));
      }
    });
  }

  void changeMatchingListener(String roomId) {
    CollectionReference roomCollection = Firestore.instance.collection('room');
    widget.listener =
        roomCollection.document(roomId).snapshots().listen((querySnapshot) {
      Map data = querySnapshot.data;
      print(data);
      updateList(data);
      if (data['isWaiting'] == "false") {
        print('Lobby Created');
        removeMatchingListener(widget.listener);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerWaiting(
                      roomId: widget.roomId,
                      size: widget.size,
                      sharedPreferences: widget.sharedPreferences,
                    )));
      }
    });
  }

  void removeMatchingListener(StreamSubscription<DocumentSnapshot> streamSub) {
    streamSub.cancel();
    print('cancel listener');
  }

  Future updateList(data) async {
    Map<String, Player> newPlayers = new Map();
    List uids = data.keys.toList();
    int n = uids.length;
    for (int i = 0; i < n; i++) {
      String key = uids[i];
//      print('$key - ');
      if (key == "" || key == "isWaiting" || key == "number" || key == "time") {
        continue;
      }
      if (players.containsKey(key)) {
        newPlayers.putIfAbsent(key, () => players[key]);
      } else {
        DocumentSnapshot result =
            await Firestore.instance.collection('users').document(key).get();
        Player nP =
            new Player(level: result.data['level'], name: result.data['displayName']);
        newPlayers.putIfAbsent(key, () => nP);
      }
    }
    if (players.length == newPlayers.length) {
      return;
    }
    players.clear();
    players = new Map();
    players.addAll(newPlayers);
    if (this.mounted) {
      setState(() {
        print('Set State Called');
      });
    }
  }
}
