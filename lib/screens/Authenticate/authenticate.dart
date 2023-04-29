import 'package:tankwar/screens/Authenticate/signin.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = true;

  void toogleView() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isSignIn) {
      return SignIn(toogleView: toogleView,);
    } else {
      return SignIn(toogleView: toogleView,);
    }
  }
}
