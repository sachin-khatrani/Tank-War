
import 'package:flutter/material.dart';
import 'package:tankwar/game_controller.dart';

class WindDisplay extends StatefulWidget {
  final GameController gameController;

  const WindDisplay({Key key, this.gameController}) : super(key: key);
  @override
  _WindDisplayState createState() => _WindDisplayState();
}

class _WindDisplayState extends State<WindDisplay> {

  TextStyle _textStyle;
  @override
  void initState() {
    widget.gameController.wind.update = updateWind;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    _textStyle = TextStyle(color: Colors.white,
        fontSize: MediaQuery.of(context).size.height * 0.03);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    print('Wind');
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wind: ${widget.gameController.wind.windPower.toInt()}',
            style: _textStyle,

          ),
          Row(
            children: [
              Text(
                'Direction: ',
                style: _textStyle,
              ),
              Icon(
                widget.gameController.wind.windPower >= 0
                    ? Icons.arrow_forward_ios
                    : Icons.arrow_back_ios,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.03,

              ),
            ],
          )
        ],
      ),
    );
  }

  void updateWind() {
    setState(() {});
  }
}
