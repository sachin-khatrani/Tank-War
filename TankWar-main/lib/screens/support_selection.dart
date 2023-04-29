import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankwar/screens/support_dialog.dart';
import 'package:tankwar/components/game_status.dart';

import '../game_controller.dart';

// ignore: must_be_immutable
class SupportSelection extends StatefulWidget {
  final GameController gameController;
  final Function updateState;
  final int playerInd;
  Map<String,int> supportMap;
  Map<String,int> prevSupportMap;

  SupportSelection({this.gameController, this.updateState, this.playerInd}) {
    supportMap = Map<String,int>();
    supportMap['Weak Shield'] = gameController.tanks[playerInd].accessories.weakShield;
    supportMap['Normal Shield'] = gameController.tanks[playerInd].accessories.normalShield;
    supportMap['Strong Shield'] = gameController.tanks[playerInd].accessories.strongShield;
    supportMap['Super Shield'] = gameController.tanks[playerInd].accessories.superShield;
    supportMap['Teleport'] = gameController.tanks[playerInd].accessories.repairKit;
    supportMap['Repair Kit'] = gameController.tanks[playerInd].accessories.teleport;

    prevSupportMap = Map<String,int>();
    prevSupportMap['Weak Shield'] = gameController.tanks[playerInd].accessories.weakShield;
    prevSupportMap['Normal Shield'] = gameController.tanks[playerInd].accessories.normalShield;
    prevSupportMap['Strong Shield'] = gameController.tanks[playerInd].accessories.strongShield;
    prevSupportMap['Super Shield'] = gameController.tanks[playerInd].accessories.superShield;
    prevSupportMap['Teleport'] = gameController.tanks[playerInd].accessories.repairKit;
    prevSupportMap['Repair Kit'] = gameController.tanks[playerInd].accessories.teleport;
  }

  @override
  _SupportSelectionState createState() => _SupportSelectionState();
}

class _SupportSelectionState extends State<SupportSelection> {
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
            'Supports',
            style: TextStyle(
                fontSize: widget.gameController.tileSize,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext context,int index) {
              return Column(
                children: <Widget>[
                  supportTile(index),
                  SizedBox(height: widget.gameController.tileSize/2,),
                ],
              );
            },
          ),


          InkWell(
            onTap: () {
              widget.gameController.tanks[widget.playerInd].accessories.weakShield = widget.supportMap['Weak Shield'];
              widget.gameController.tanks[widget.playerInd].accessories.normalShield = widget.supportMap['Normal Shield'];
              widget.gameController.tanks[widget.playerInd].accessories.strongShield = widget.supportMap['Strong Shield'];
              widget.gameController.tanks[widget.playerInd].accessories.superShield = widget.supportMap['Super Shield'];
              widget.gameController.tanks[widget.playerInd].accessories.repairKit = widget.supportMap['Repair Kit'];
              widget.gameController.tanks[widget.playerInd].accessories.teleport = widget.supportMap['Teleport'];
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


  Widget supportTile(int index) {
    if(index == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getSupport(
            name: 'Teleport',
            imgName: 'teleport2',
            quantity: widget.supportMap['Teleport'],
            price: 2000,
          ),
          getSupport(
            name: 'Repair Kit',
            imgName: 'repair-kit',
            quantity: widget.supportMap['Repair Kit'],
            price: 2000,
            color: Colors.grey[300],
          ),
        ],
      );
    } else if (index == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getSupport(
            name: 'Weak Shield',
            imgName: 'weak',
            quantity: widget.supportMap['Weak Shield'],
            price: 2000,
            color: Colors.grey[300],
          ),
          getSupport(
            name: 'Normal Shield',
            imgName: 'normal',
            quantity: widget.supportMap['Normal Shield'],
            price: 2000,
          ),
        ],
      );
    } else if (index == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getSupport(
            name: 'Strong Shield',
            imgName: 'strong',
            quantity: widget.supportMap['Strong Shield'],
            price: 2000,
          ),
          getSupport(
            name: 'Super Shield',
            imgName: 'super',
            quantity: widget.supportMap['Super Shield'],
            price: 2000,
          ),
        ],
      );
    }
  }

  Widget getSupport({String name, String imgName, int quantity, int price, Color color}) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) =>
            SupportDialog(
              gameController: widget.gameController,
              updateSupport: updateSupport,
              mySupport: quantity,
              prevSupport: widget.prevSupportMap[name],
              price: price,
              supportName: name,
            ),
        );
        print('Tapped on $name');
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
              height: widget.gameController.screenSize.height / 9,
              width: widget.gameController.screenSize.width / 4,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/$imgName.png' ,
                      width: widget.gameController.tileSize * 0.9,
                      height: widget.gameController.tileSize * 0.9,
                      color: color,
                    ),
                  ),
                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        name,
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
                  price.toString(),
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
                  quantity.toString(),
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

  void updateSupport(String name,int curCount) {
    setState(() {
      widget.supportMap[name] = curCount;
    });
  }

}
