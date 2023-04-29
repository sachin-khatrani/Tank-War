import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/screens/Online_Mode/splashScreen.dart';

class LoadingScreen extends StatefulWidget {
  final String message;
  final bool isRandom;
  String roomId;
  final Size size;
  final SharedPreferences sharedPreferences;

  LoadingScreen({Key key, this.message, this.isRandom, this.size, this.sharedPreferences}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message == "Match") {
      makeEntry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.brown[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: SpinKitChasingDots(
                color: Colors.brown,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makeEntry() async {
    var function =
        CloudFunctions.instance.getHttpsCallable(functionName: 'entry');
    dynamic response = await function.call().then((result) {
      return result.data['room'];
    });
    print(response);
    print("roomId-->" + response);
    widget.roomId = response;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SplashScreen(size: widget.size, roomId: widget.roomId,isRandom: widget.isRandom,sharedPreferences: widget.sharedPreferences,)));
  }
}
