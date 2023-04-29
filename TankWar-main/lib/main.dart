import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankwar/components/Tank.dart';
import 'package:tankwar/screens/controller.dart';
import 'package:tankwar/screens/splash.dart';
import 'package:tankwar/services/auth.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//  await Tank.loadTanks();
  SystemChrome
      .setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    TapGestureRecognizer tapper = TapGestureRecognizer();
//  tapper.onTapDown = gameController.onTapDown;
    flameUtil.addGestureRecognizer(tapper);
    Size size = await Flame.util.initialDimensions();
    runApp(SplashScreenGame(
      sharedPreferences: sharedPreferences,
      size: size,
    ));}
  );


}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  const MyApp({Key key, this.sharedPreferences, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Scaffold(
            body: Controller(
              sharedPreferences: sharedPreferences,
              size: size,
            )),
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreenGame extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final Size size;

  const SplashScreenGame({Key key, this.sharedPreferences, this.size})
      : super(key: key);

  @override
  _SplashScreenGameState createState() => _SplashScreenGameState();
}

class _SplashScreenGameState extends State<SplashScreenGame> {
  int state = 1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return getScreen();
  }

  Widget getScreen() {
    Widget widget = Container();
    if (state == 1)
      widget = MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Splash1(
            function: () {
              this.setState(() {
                this.state++;
              });
            },
          ),
        ),
      );
    else if (state == 2)
      widget = MyApp(
        sharedPreferences: this.widget.sharedPreferences,
        size: this.widget.size,
      );
    return widget;
  }
}

//import 'package:flame/flame.dart';
//import 'package:flame/util.dart';
//import 'package:flutter/gestures.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:tankwar/screens/player_selection.dart';
//
//import 'game_controller.dart';
//
//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  Util flameUtil = Util();
//  await flameUtil.fullScreen();
//  await flameUtil.setOrientations(
//      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//  Size size = await Flame.util.initialDimensions();
//  SharedPreferences storage = await SharedPreferences.getInstance();
//  TapGestureRecognizer tapper = TapGestureRecognizer();
////  tapper.onTapDown = gameController.onTapDown;
//  flameUtil.addGestureRecognizer(tapper);
//
//  runApp(GameWidget(
//    gameController: null,
//    size: size,
//    sharedPreferences: storage,
//  ));
//}
//
//class GameWidget extends StatefulWidget {
//  final GameController gameController;
//  final SharedPreferences sharedPreferences;
//  final Size size;
//
//  GameWidget({Key key, this.gameController, this.sharedPreferences, this.size})
//      : super(key: key);
//
//  @override
//  _GameWidgetState createState() => _GameWidgetState();
//}
//
//class _GameWidgetState extends State<GameWidget> {
//  @override
//  void initState() {
//    super.initState();
//    SystemChrome.setEnabledSystemUIOverlays([]);
//    SystemChrome.setPreferredOrientations(
//        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Tanks',
//      home: Scaffold(
//        body: PlayerSelection(
//          sharedPreferences: widget.sharedPreferences,
//          size: widget.size,
//        ),
//      ),
//    );
//  }
//}
