import 'package:tankwar/services/auth.dart';
import 'package:tankwar/shared/constant.dart';
import 'package:tankwar/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_web_view.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  const SignIn({Key key, this.toogleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[500],
        title: Text('Sign in to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toogleView();
            },
            icon: Icon(Icons.person_outline),
            label: Text('Register'),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover,
            )
        ),
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Email',
                ),
                validator: (val) =>  val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Password',
                ),
                validator: (val) => val.length < 8 ? 'Enter password 8 character long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 30.0,),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {


                      if(_formKey.currentState.validate()) {
                        setState(() => isLoading = true);
                        dynamic result = await _authService.signInWithEmail(email, password);
                        if(result == null) {
                          setState(() {
                            error = 'This email or password is incorrect';
                            isLoading = false;
                          });
                        }
                      }

                    },
                    child: Text('Sign In'),
                    color: Colors.pink[400],
                  ),
                  SizedBox(width: 20,),
                  RaisedButton(
                    onPressed: () async {
                      String clientId = "686889071911614";
                      String redirectUrl = "https://www.facebook.com/connect/login_success.html";

                      String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomWebView(
                              selectedUrl:
                              'https://www.facebook.com/dialog/oauth?client_id=$clientId&redirect_uri=$redirectUrl&response_type=token&scope=email,public_profile,user_friends',
                            ),
                            maintainState: true),
                      );
                      if(result != null) {
                        dynamic res = await _authService.signInWithFacebook(result);
                      }
                    },
                    child: Text('Sign In with FB'),
                    color: Colors.pink[400],
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
