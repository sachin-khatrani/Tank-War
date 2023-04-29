import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:tankwar/screens/dialog_helper.dart';
import 'package:tankwar/screens/weapon_dialog.dart';
import 'package:tankwar/components/game_status.dart';
import 'package:tankwar/components/weapons.dart';

import '../game_controller.dart';

// ignore: must_be_immutable
class WeaponSelection extends StatefulWidget {
  final GameController gameController;
  final Function updateState;
  final List<Weapon> previousWeapons;
  List<int> newWeapons;
  final int playerInd;

  WeaponSelection({this.gameController, this.updateState, this.previousWeapons, this.playerInd}) {
    newWeapons = List<int>();
    for(Weapon w in previousWeapons) {
      newWeapons.add(w.quantity);
    }
  }

  @override
  _WeaponSelectionState createState() => _WeaponSelectionState();
}

class _WeaponSelectionState extends State<WeaponSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Weapon-background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: widget.gameController.tileSize / 10,),
          Text(
            'Weapons',
            style: TextStyle(
              fontSize: widget.gameController.tileSize,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context,int index) {
              return Column(
                children: <Widget>[
                  weaponTile(index),
                  SizedBox(height: widget.gameController.tileSize/5,)
                ],
              );
            },
          ),


          InkWell(
            onTap: () {
              int ind = 0;
              for(Weapon w in widget.gameController.tanks[widget.playerInd].accessories.weapons) {
                w.quantity = widget.newWeapons[ind];
                ind++;
              }
              widget.gameController.gameStatus = Status.roundOver;
              widget.updateState();
            },

            child: Container(
              height: widget.gameController.screenSize.height / 9,
              width: widget.gameController.screenSize.width / 10,
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
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.gameController.tileSize / 1.65
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  Widget weaponTile(int index) {
    print(widget.playerInd);
//    print("${widget.previousWeapons[2*index].quantity} ----> ${widget.newWeapons[2*index]} ---> ${2*index}");
//    print("${widget.previousWeapons[2*index+1].quantity} ----> ${widget.newWeapons[2*index+1]} ---> ${2*index+1}");
//    Weapon weapon = widget.gameController.tanks[widget.playerInd].accessories.weapons[2*index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        getWeapon(
          widget.previousWeapons[2*index],
          widget.newWeapons[2*index],
          2*index
        ),
        getWeapon(
          widget.previousWeapons[2*index+1],
          widget.newWeapons[2*index+1],
          2*index+1
        ),
      ],
    );
  }

  Widget getWeapon(Weapon weapon, int prevWeapon, int index) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) =>
          WeaponDialog(
            myWeapon: weapon,
            gameController: widget.gameController,
            updateWeapon: updateWeapon,
            prevWeapon: prevWeapon,
            index: index,
          )
        );
        print('Tapped on ${weapon.name}');
      },
      child: Container(
        height: widget.gameController.screenSize.height / 8,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
//            color: Colors.blueGrey,
              height: widget.gameController.screenSize.height / 9,
              width: widget.gameController.screenSize.width / 4,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/${weapon.img}' ,
                      width: widget.gameController.tileSize * 0.9,
                      height: widget.gameController.tileSize * 0.9,
                    ),
                  ),
                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        weapon.name,
                        style: TextStyle(
                          fontSize: widget.gameController.tileSize/1.65,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              height: widget.gameController.screenSize.height / 9,
              width: 0.0,
              child: VerticalDivider(
                color: Colors.grey[400],
                thickness: 2.0,
              ),
            ),

            Container(
              height: widget.gameController.screenSize.height / 9,
              width: widget.gameController.screenSize.width / 11,
              child: Center(
                child: Text(
                  weapon.price.toString(),
                  style: TextStyle(
                    fontSize: widget.gameController.tileSize/1.65,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Container(
              height: widget.gameController.screenSize.height / 9,
              width: 0.0,
              child: VerticalDivider(
                color: Colors.grey[400],
                thickness: 2.0,
              ),
            ),

            Container(
              height: widget.gameController.screenSize.height / 9,
              width: widget.gameController.screenSize.width / 20,
              child: Center(
                child: Text(
                  widget.newWeapons[index].toString(),
                  style: TextStyle(
                    fontSize: widget.gameController.tileSize/1.65,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }

  void updateWeapon(int ind, int curCount) {
    setState(() {
      widget.newWeapons[ind] = curCount;
    });
  }
}
