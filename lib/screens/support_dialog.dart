import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game_controller.dart';

// ignore: must_be_immutable
class SupportDialog extends StatefulWidget {
  int curCount = 0;
  int strength = 0;
  final String supportName;
  final int prevSupport;
  final int price;
  final int mySupport;
  final GameController gameController;
  final Function updateSupport;

  SupportDialog({Key key, this.prevSupport, this.gameController, this.updateSupport, this.mySupport, this.supportName, this.price}) {
    curCount = mySupport;
    if(supportName == 'Weak Shield') {
      strength = 100;
    } else if(supportName == 'Super Shield') {
      strength = 400;
    } else if(supportName == 'Normal Shield') {
      strength = 200;
    } else if(supportName == 'Strong Shield') {
      strength = 300;
    }
  }


  @override
  _SupportDialogState createState() => _SupportDialogState();
}

class _SupportDialogState extends State<SupportDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: Colors.grey[400],
              width: 5.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            )
        ),
        height: widget.gameController.screenSize.height / 1.5,
        width: widget.gameController.screenSize.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              width: widget.gameController.screenSize.width / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: widget.gameController.tileSize*1.3,
                    child: RaisedButton(
                      color: Colors.grey[800],
                      child: Text(
                        '-',
                        style: TextStyle(
                          fontSize: widget.gameController.tileSize/1.65,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _sellSupport,
                    ),
                  ),

                  Text(
                    widget.curCount.toString(),
                    style: TextStyle(
                        fontSize: widget.gameController.tileSize/1.65,
                        color: Colors.white
                    ),
                  ),

                  ButtonTheme(
                    minWidth: widget.gameController.tileSize*1.3,
                    child: RaisedButton(
                      color: Colors.grey[800],
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: widget.gameController.tileSize/1.65,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _buySupport,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: widget.gameController.tileSize / 6,
            ),

            Text(
              '${widget.supportName}',
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.gameController.tileSize / 1.5,
              ),
            ),


            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'price: ${widget.price}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.gameController.tileSize / 2,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'strength: ${widget.strength}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.gameController.tileSize / 2,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  'This Shield is weak shield',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.gameController.tileSize / 2,
                  ),
                ),
              ),
            ),


            ButtonTheme(
              minWidth: widget.gameController.tileSize*2,
              child: RaisedButton(
                color: Colors.grey[800],
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: widget.gameController.tileSize/1.65,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  widget.updateSupport(widget.supportName, widget.curCount);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buySupport() {
    // reduce score
    setState(() {
      // If enough money..
      widget.curCount++;
    });
  }

  void _sellSupport() {
    // increase score
    setState(() {
//      print(widget.myWeapon.quantity);
      if(widget.curCount > widget.prevSupport) {
        widget.curCount--;
      }
    });
  }

}
