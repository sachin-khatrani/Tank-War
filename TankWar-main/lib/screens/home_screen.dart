import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/models/user.dart';
import 'package:tankwar/screens/popup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'PlayPopup.dart';
import 'custom_button.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  const HomeScreen({Key key, this.sharedPreferences, this.size})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((value) => print(value));
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> map) async {
      print(map['data']);
//        print(map['data']['ack']);
      if (map['data']['ack'] == null) {
        post('https://fcm.googleapis.com/fcm/send',
            headers: {
              'Authorization':
                  'Key=AAAAfE4tr2A:APA91bEd8toqomip3zumdtS7WqGlq_q_8SSy8o4Rz-WK_YNa0rRy3YuNoRGbqFJcf1u8wUSeR7cBunKiRAARtXD8uQcZ8NsIWU61I09kA_K9AuvD-rs9hbLM-UVz394mmgb_5T_-PRgo',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              'to':
                  'e1aGCh0l3MQ:APA91bGpyuvg0p6kAlnWorj7jNehW59kFVynMxc92P3hTn-HcSPrBhiubKqIaxdFzxn7jWL1NPW8008IssBqifXxuotEvRiD8g-F1XLeU1Dpq8-jwZU-eBT3I7OkZMFKudjlAkSB0um6',
              'collapse_key': 'type_a',
              'data': {
                'ack': 'Ack',
              }
            })).then((value) {
          print(value.body);
        });
      }
    });
  }

  Size size;
  double tileSize;
  User user;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    tileSize = size.width / 16;
    user = Provider.of<User>(context);
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.fill)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // Avatar
                  width: tileSize * 1.25,
                  height: tileSize * 1.25,
                  margin:
                      EdgeInsets.fromLTRB(tileSize * 0.2, tileSize * 0.1, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(width: tileSize * 0.1),
                  ),
                  child: user.photoUrl.contains('http')
                      ? CachedNetworkImage(
                          imageUrl: user.photoUrl,
                          placeholder: (context, url) => SpinKitFadingCircle(
                            color: Colors.white,
                            size: tileSize * 0.75,
                          ),
                        )
                      : Container(),
                ),
                Container(
                  width: tileSize,
                  height: tileSize,
                  margin:
                      EdgeInsets.fromLTRB(0, tileSize * 0.1, tileSize * 0.2, 0),
                  child: Icon(Icons.settings),
                ),
              ],
            ),
            SizedBox(
              height: tileSize,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: tileSize,
                      height: tileSize,
                      margin: EdgeInsets.fromLTRB(0, 0, tileSize * 0.25, 0),
                      decoration: BoxDecoration(
                          border: Border.all(width: tileSize * 0.1),
                          color: Colors.blueGrey[800].withOpacity(0.5)),
                    ),
                    Container(
                      width: tileSize,
                      height: tileSize,
                      margin: EdgeInsets.fromLTRB(
                          0, tileSize * 0.25, tileSize * 0.25, 0),
                      decoration: BoxDecoration(
                          border: Border.all(width: tileSize * 0.1),
                          color: Colors.blueGrey[800].withOpacity(0.5)),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: tileSize / 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  //Friends
                  width: tileSize * 1.5,
                  height: tileSize * 1.5,
                  margin: EdgeInsets.fromLTRB(
                      tileSize * 0.2, 0, 0, tileSize * 0.25),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: tileSize * 0.05, color: Colors.black),
                      color: Colors.orange[200].withOpacity(0.3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FancyButton(
                    child: Text(
                      'Play',
                      style: TextStyle(
                          fontSize: tileSize * 0.8,
                          fontFamily: 'Capture_it',
                          color: Colors.white),
                    ),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: PopupDialog(
                                size: Size(400, 300),
                                child: PlayPopUp(
                                  size: widget.size,
                                  sharedPreferences: widget.sharedPreferences,
                                )),
                          ));
                    },
                    color: Colors.orange[200].withOpacity(0.2).withAlpha(60),
                    size: tileSize * 2,
                    duration: Duration(milliseconds: 200),
                  ),
                ),
                Container(
                  width: tileSize * 1.5,
                  height: tileSize * 1.5,
                  margin: EdgeInsets.fromLTRB(
                      0, 0, tileSize * 0.2, tileSize * 0.25),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: tileSize * 0.05, color: Colors.black),
                      color: Colors.orange[200].withOpacity(0.3)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
