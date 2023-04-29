import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash1 extends StatefulWidget {

  final Function function;

  const Splash1({Key key,@required this.function}) : super(key: key);

  @override
  _Splash1State createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        onEnd: () {
          widget.function();
        },
        duration: Duration(milliseconds: 500),
        opacity: _visible ? 0.0 : 1.0,

        child: TyperAnimatedTextKit(
          text: ['code4ij'],
          textStyle: TextStyle(
            letterSpacing: 2.0,
            fontSize: 30,
            fontFamily: 'Capture_it',

          ),
          speed: Duration(milliseconds: 200),
          isRepeatingAnimation: false,
          onFinished: () {
            print('finished');
            setState(() {
              _visible = !_visible;
            });
          },
        ),
      ),
    );
  }
}
