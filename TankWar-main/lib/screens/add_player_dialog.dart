import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPlayerDialog extends StatefulWidget {
  final double tileSize;
  String playerName = "";
  String playerColor;
  bool isBot = false;
  final List<MaterialColor> availableTanks;
  final Function addPlayer;
  TextEditingController textEditingController = TextEditingController();
  AddPlayerDialog({Key key, this.availableTanks, this.tileSize, this.addPlayer})
      : super(key: key);

  @override
  _AddPlayerDialogState createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            border: Border.all(
              color: Colors.blueGrey,
              width: 5.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  hintText: widget.playerName == "" ? "Enter Name" : "",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.tileSize * 0.17089),
                    borderSide: BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                maxLines: 1,
                toolbarOptions: ToolbarOptions(
                  cut: true,
                  copy: true,
                  selectAll: true,
                  paste: true,
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
                  widget.playerName = widget.textEditingController.text;
                },
              ),

              getTanks(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: widget.isBot,
//                  checkColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        widget.isBot = (widget.isBot) ? false : true;
                      });
                    },
                  ),
                  Text(
                    'computer',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              RaisedButton(
                child: Text("Add"),
                onPressed: () {
                  if(widget.playerName.length > 0 && widget.playerColor != null) {
                    widget.addPlayer(widget.playerName, widget.playerColor, widget.isBot);
                    Navigator.of(context).pop();
                  } else {

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTanks() {
    List<Widget> tanks = List();

    for(int i=0;i<widget.availableTanks.length;i++) {
      bool isSelected = false;
      if(widget.playerColor != null) {
        if(widget.playerColor == "amber" && widget.availableTanks[i] == Colors.amber) {
          isSelected = true;
        } else if(widget.playerColor == "blue" && widget.availableTanks[i] == Colors.blue) {
          isSelected = true;
        } else if(widget.playerColor == "green" && widget.availableTanks[i] == Colors.green) {
          isSelected = true;
        } else if(widget.playerColor == "brown" && widget.availableTanks[i] == Colors.brown) {
          isSelected = true;
        } else if(widget.playerColor == "yellow" && widget.availableTanks[i] == Colors.yellow) {
          isSelected = true;
        } else if(widget.playerColor == "pink" && widget.availableTanks[i] == Colors.pink) {
          isSelected = true;
        } else if(widget.playerColor == "lightGreen" && widget.availableTanks[i] == Colors.lightGreen) {
          isSelected = true;
        }
      }
      Widget tank = InkWell (
        child: Container(
          height: widget.tileSize,
          width: widget.tileSize,
          decoration: BoxDecoration(
            color: widget.availableTanks[i],
            border: Border.all(
              color: Colors.black45,
              width: isSelected ? widget.tileSize/5 : 0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onTap: () {
          setState(() {
            if(widget.availableTanks[i] == Colors.amber) {
              widget.playerColor = "amber";
            } else if(widget.availableTanks[i] == Colors.blue) {
              widget.playerColor = "blue";
            } else if(widget.availableTanks[i] == Colors.green) {
              widget.playerColor = "green";
            } else if(widget.availableTanks[i] == Colors.brown) {
              widget.playerColor = "brown";
            } else if(widget.availableTanks[i] == Colors.yellow) {
              widget.playerColor = "yellow";
            } else if(widget.availableTanks[i] == Colors.pink) {
              widget.playerColor = "pink";
            } else if(widget.availableTanks[i] == Colors.lightGreen) {
              widget.playerColor = "lightGreen";
            }
          });
        }
      );
      tanks.add(tank);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: tanks,
    );
  }
}
