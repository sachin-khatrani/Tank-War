import 'package:flutter/cupertino.dart';
import 'package:tankwar/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/background.jpg')))),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            )),
        Container(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/paper-48294.png'),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 10,
                        MediaQuery.of(context).size.width / 10,
                        MediaQuery.of(context).size.width / 10,
                        MediaQuery.of(context).size.width / 25),
                    child: Text(
                      'Tank War',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 18,
                          fontFamily: 'Capture_it',
                          color: Colors.brown[800]),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton.icon(
                            color: Color(0xFF475a96),
                            onPressed: () async {
                              dynamic res = await AuthService()
                                  .showFacebookSignin(context);
                              if (res != null) {
                                print('Logged in');
                              }
                            },
                            icon: Image.asset('assets/images/facebook.png',
                                width: MediaQuery.of(context).size.width / 22,
                                height: MediaQuery.of(context).size.width / 18),
                            label: Text('Continue with Facebook')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 50,
                        ),
                        RaisedButton.icon(
                            color: Colors.white,
                            onPressed: () {},
                            icon: Image.asset('assets/images/google.ico',
                                width: MediaQuery.of(context).size.width / 22,
                                height: MediaQuery.of(context).size.width / 18),
                            label: Text(
                              'Continue with Google',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 50,
                        ),
                        RaisedButton.icon(
//                            color: Colors.white,
                            onPressed: () async {
                              print('onPressed');
                              setState(() {
                                showLoading = true;
                              });
                              // dynamic user = await Future.delayed(Duration(seconds: 2), () => null);
                              dynamic user = await AuthService().signInAnonymously();
                              if(user == null) {
                                setState(() {
                                  showLoading = false;
                                });
                              }

                            },
                            icon: FaIcon(FontAwesomeIcons.user,
                              size: MediaQuery.of(context).size.width / 20,
                            ),
                            label: Text(
                              'Continue as Guest',
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if(showLoading)
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.withOpacity(0.001),
          ),
        if(showLoading)
          Center(child: CircularProgressIndicator())
      ],
    );
  }
}