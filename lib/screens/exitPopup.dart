import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExitPopUp extends StatefulWidget {
  final Function setExit;

  ExitPopUp({Key key, this.setExit}) : super(key: key);
  @override
  _ExitPopUpState createState() => _ExitPopUpState();
}

class _ExitPopUpState extends State<ExitPopUp> {
  @override
  Widget build(BuildContext context) {
//    widget.tileSize = MediaQuery.of(context).size.width / 22.5;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            border: Border.all(
              color: Colors.blueGrey,
              width: 5.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Are  You Sure to Want to Exit"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text('Yes'),
                    onPressed: () {
                      widget.setExit(true);
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('No'),
                    onPressed: () {
                      widget.setExit(false);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
