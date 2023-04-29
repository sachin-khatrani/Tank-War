import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/models/user.dart';

import 'home_screen.dart';
import 'login.dart';

class Controller extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  const Controller({Key key, this.sharedPreferences, this.size})
      : super(key: key);

  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  @override
  Widget build(BuildContext context) {
    bool login = widget.sharedPreferences.getBool('isLoggedIn');
    final user = Provider.of<User>(context);
    print(user ?? 'No user');
    if (user == null) {
      if (login == null || login == false)
        return LoginScreen();
      else
        return Container();
    } else {
      return HomeScreen(
        sharedPreferences: widget.sharedPreferences,
        size: widget.size,
      );
    }
  }
}
