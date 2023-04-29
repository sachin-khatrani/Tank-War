import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/components/weapons.dart';
import 'package:tankwar/game_controller.dart';

// ignore: must_be_immutable
class WeaponDialog extends StatefulWidget {
  final Weapon myWeapon;
  int curCount = 0;
  final int prevWeapon;
  final GameController gameController;
  final Function updateWeapon;
  final int index;

  WeaponDialog({this.myWeapon, this.gameController, this.updateWeapon, this.prevWeapon, this.index}) {
    curCount = prevWeapon;
  }


  _WeaponDialogState createState() => _WeaponDialogState();
}

class _WeaponDialogState extends State<WeaponDialog> {
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
                      onPressed: _sellWeapon,
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
                      onPressed: _buyWeapon,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: widget.gameController.tileSize / 6,
            ),

            Text(
              '${widget.myWeapon.name}',
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
                    'radius: 60',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.gameController.tileSize / 2,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'price: ${widget.myWeapon.price}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.gameController.tileSize / 2,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'damage: 500',
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
                  'Fire ball is basic attacking weapon for tank.....',
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
                  widget.updateWeapon(widget.index, widget.curCount);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buyWeapon() {
    // reduce score
    setState(() {
      // If enough money..
      widget.curCount++;
    });
//    print('${widget.weapon.quantity}  ${widget.gameController.tank.accessories.weapons[0].quantity}');
  }

  void _sellWeapon() {
    // increase score
    setState(() {
//      print(widget.myWeapon.quantity);
      if(widget.curCount > ((widget.myWeapon == null)?0:widget.myWeapon.quantity)) {
        widget.curCount--;
      }
    });
  }

}
