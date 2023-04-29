import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tankwar/models/player.dart';
import 'package:tankwar/screens/Online_Mode/match_timer.dart';

class OnlineLobby extends StatefulWidget {
  final double tileSize;
  final bool isRandom;
  final String roomId;

  OnlineLobby({Key key, this.tileSize, this.isRandom, this.roomId})
      : super(key: key);

  @override
  _OnlineLobbyState createState() => _OnlineLobbyState();
}

class _OnlineLobbyState extends State<OnlineLobby> {
  List<dynamic> allPlayers;

  @override
  Widget build(BuildContext context) {
    allPlayers = players.values.toList();
    int n = allPlayers.length;
    Widget firstPlayer, secondPlayer, thirdPlayer;
    Widget forthPlayer, fifthPlayer, sixthPlayer;

    firstPlayer = (n >= 1) ? getProfile(0) : getEmptyProfile();
    secondPlayer = (n >= 2) ? getProfile(1) : getEmptyProfile();
    thirdPlayer = (n >= 3) ? getProfile(2) : getEmptyProfile();
    forthPlayer = (n >= 4) ? getProfile(3) : getEmptyProfile();
    fifthPlayer = (n >= 5) ? getProfile(4) : getEmptyProfile();
    sixthPlayer = (n >= 6) ? getProfile(5) : getEmptyProfile();
    Widget startButton = (!widget.isRandom)
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: FlatButton(
              color: Colors.grey,
              child: Text("Start"),
              onPressed: () async {
                print('Matching');
                CloudFunctions cf = CloudFunctions();
                print(cf);
                final HttpsCallable httpsCallable =
                    cf.getHttpsCallable(functionName: 'matchingQueue');
                print(httpsCallable);
                dynamic response = await httpsCallable.call(
                  <String, dynamic>{
                    'roomId': widget.roomId,
                  },
                );
              },
            ),
          )
        : Container();

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // First Row
            Row(
              children: [
                firstPlayer,
                secondPlayer,
                thirdPlayer,
                Expanded(
                  child: Column(
                    children: [
                      startButton,
                      FlatButton(
                        color: Colors.grey,
                        child: Text("Exit"),
                        onPressed: () async {
                          print('cancel Matching');
                          CloudFunctions cf = CloudFunctions();
                          print(cf);
                          final HttpsCallable httpsCallable = cf
                              .getHttpsCallable(functionName: 'cancleRequest');
                          print(httpsCallable);
                          var response = await httpsCallable.call(
                            <String, dynamic>{
                              'roomId': widget.roomId,
                            },
                          );
                          if (response.data['cancel'] == 'success') {
                            Navigator.pop(context);
                          } else {
                            print('error in cancel request');
                          }
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
                    child: MatchTimer(
                  roomId: widget.roomId,
                )),
                forthPlayer,
                fifthPlayer,
                sixthPlayer,
              ],
            ),
          ],
        ),
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
              "Waiting...",
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
                      color: Colors.blue,
                      border: Border.all(width: 5.0, color: Colors.blueGrey),
                    ),
                    height: widget.tileSize * 3.3,
                    width: widget.tileSize * 3.3,
                  ),
                ),
              ),
              Container(
                width: widget.tileSize * 0.8,
                height: widget.tileSize * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: Center(
                  child: Text(
                    '${allPlayers[i].level}',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
                  ),
                ),
              )
            ],
          ),
          Container(
            child: Text(allPlayers[i].name),
          ),
        ],
      ),
    );
  }
}
