import 'package:flutter/material.dart';
import 'package:tankwar/game_controller.dart';

class ScoreDisplay extends StatefulWidget {
  final GameController gameController;

  const ScoreDisplay({Key key, this.gameController}) : super(key: key);
  @override
  _ScoreDisplayState createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  void initState() {
    widget.gameController.updateScore = updateScore;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.gameController.tanks.map((tank) => Container(
          child: Text('${tank.playerName}: ${tank.totalScore.toDouble()}', style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.height * 0.03
          ),),
        )).toList(),
      ),
    );
  }

  void updateScore() {
    setState(() {

    });
  }
}