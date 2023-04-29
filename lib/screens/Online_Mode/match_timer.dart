import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

class MatchTimer extends StatefulWidget {
  final String roomId;
  MatchTimer({Key key, this.roomId}) : super(key: key);

  @override
  _MatchTimerState createState() => _MatchTimerState();
}

class _MatchTimerState extends State<MatchTimer> {
  Timer _timer;
  int second = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    int min = second ~/ 60;
    int showSecond = second - min * 60;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 15),
      child: Text(
        '$min:$showSecond',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 15,
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (this.mounted) {
          setState(
            () {
              if (second == 10) {
                // call match
                matchingStart();
                second += 1;
              } else {
                second += 1;
                print(second);
              }
            },
          );
        }
      },
    );
  }

  Future matchingStart() async {
    var function =
        CloudFunctions.instance.getHttpsCallable(functionName: 'matchingQueue');
    dynamic response = await function.call(
      <String, dynamic>{
        'roomId': widget.roomId,
      },
    ).then((result) {
      print('Matching Completes');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
}
