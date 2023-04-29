import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PopupDialog extends StatefulWidget {
  final Widget child;
  final Size size;

  const PopupDialog({Key key, this.child,@required this.size}) : super(key: key);
  _PopupDialogState createState() => _PopupDialogState();
}

class _PopupDialogState extends State<PopupDialog> with SingleTickerProviderStateMixin{

  bool animated = false;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate
    );

    _animationController.forward();

    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          animated = true;
        });
      }
    });
  }

  @override
  void dispose(){
    _animationController.removeListener(() { });
    _animationController.removeStatusListener((status) { });
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(

      child: Container(
        height: widget.size.height,
        width: widget.size.width,
        decoration: !animated ? BoxDecoration() : BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/paper-48294.png'),
            fit: BoxFit.fill
          ),
        ),
        child: !animated ? ClipRect(
          clipper: CustomRectClipper(width: widget.size.width, height: _animation.value * widget.size.height),
          child: Container(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/paper-48294.png'),
                fit: BoxFit.fill
              )
            ),

          ),
        ) : widget.child,

      ),
      backgroundColor: Colors.transparent,


    );
  }

}


class CustomRectClipper extends CustomClipper<Rect> {
  double width;
  double height;

  CustomRectClipper({this.width, this.height});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}