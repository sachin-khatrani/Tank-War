import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/components/game_status.dart';
import 'package:tankwar/game_controller.dart';

class WeaponSupport extends StatefulWidget {
  final GameController gameController;
  final Function updateState;
  int curPlayer;
  WeaponSupport({Key key, this.gameController, this.updateState, this.curPlayer}) : super(key: key);

  @override
  _WeaponSupportState createState() => _WeaponSupportState();
}

class _WeaponSupportState extends State<WeaponSupport> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Weapon-background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: widget.gameController.screenSize.height / 7,
            width: widget.gameController.screenSize.width / 4,
            decoration: BoxDecoration(
                color: Colors.black54,
            ),
            child: Center(
              child: Text(
                "Player ${widget.curPlayer + 1}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.gameController.tileSize * 0.8
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getButton('Weapons'),
              getButton('Support'),
            ],
          ),
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  nextPlayer();
                },
                child: Container(
                  height: widget.gameController.screenSize.height / 9,
                  width: widget.gameController.screenSize.width / 5,
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      border: Border.all(
                        color: Colors.grey[400],
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      )
                  ),

                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.gameController.tileSize / 1.65
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: widget.gameController.tileSize,)
            ],
          ),
        ],
      ),
    );
  }

  Widget getButton(String buttonName) {
    return InkWell(
      onTap: () {
        if(buttonName == 'Weapons') {
          widget.gameController.gameStatus = Status.weapon;
          widget.updateState();
        } else if(buttonName == 'Support') {
          widget.gameController.gameStatus = Status.support;
          widget.updateState();
        } else if(buttonName == 'Next') {
          nextPlayer();
        }
      },

      child: Container(
        height: widget.gameController.screenSize.height / 9,
        width: widget.gameController.screenSize.width / 5,
        decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: Colors.grey[400],
              width: 5.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            )
        ),

        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
                color: Colors.white,
                fontSize: widget.gameController.tileSize / 1.65
            ),
          ),
        ),
      ),
    );
  }

  void nextPlayer() {
    print('Next Player');
    if(widget.curPlayer == widget.gameController.noOfPlayer-1) {
      // Make all players Alive and full Health
      widget.gameController.gameStatus = Status.playing;
      widget.updateState(ind: 0);
    }
    else
      widget.updateState(ind: 0);
  }
}
