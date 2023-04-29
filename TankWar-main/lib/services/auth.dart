
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tankwar/models/user.dart';
import 'package:tankwar/screens/Authenticate/custom_web_view.dart';
import 'package:tankwar/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final AuthService _instance = AuthService._internal();
  String accessToken;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // To create user based on FirebaseUser
  User _createUser(FirebaseUser user) {
    if(user != null) {
      String uid = user.uid;
      String displayName;
      Random r = new Random();
      String photoUrl = user.photoUrl??'default';
      try{
        displayName = user.displayName ?? user.email.split('@')[0];
      } catch(e) {
        displayName = 'Guest' + (r.nextInt(1000000)+1000000).toString();
      }
      return User(
        displayName: displayName,
        photoUrl: photoUrl,
        uid: uid
      );
    }

    return null;
  }

  // Stream to listen for Sign in-out
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_createUser);
  }

  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _createUser(res.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future signOut() async {
    try {
      (await SharedPreferences.getInstance()).setBool('isLoggedIn', false);
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInWithFacebook(String token) async {
    this.accessToken = token;
    try {

      final credential = FacebookAuthProvider.getCredential(accessToken: token);
      final res = await _auth.signInWithCredential(credential);

      String fid = jsonDecode((await get('https://graph.facebook.com/me?access_token=$token')).body)['id'];

      User user = _createUser(res.user);
      user.facebookId = fid;
      user.friends = await facebookFriends();
      createUserProfile(user, RegisterMode.Facebook);
      (await SharedPreferences.getInstance()).setBool('isLoggedIn', true);

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future createUserProfile(User user, RegisterMode registerMode) async {
    return await DatabaseService(uid: user.uid).createUserProfile(registerMode: registerMode, user: user);
  }

  Future facebookFriends() async {
    List result = jsonDecode((await get('https://graph.facebook.com/me/friends?access_token=$accessToken')).body)['data'];
    List list = result.map((e) {
      if(e['id'] != null)
        return e['id'];
    }).toList();
    List<String> uidList = List<String>();
    DocumentSnapshot value = await DatabaseService().userCollection.document('uid_map').get();
    uidList = list.map((e) => value.data[e.toString()].toString()).toList();
    return uidList;
  }

  Future showFacebookSignin(BuildContext context) async {
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
    SystemChrome.setEnabledSystemUIOverlays([]);
    if(result != null) {
      try {
        return await signInWithFacebook(result);
      } catch(e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future signInAnonymously() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      User user = _createUser(result.user);
      createUserProfile(user, RegisterMode.Anonymous);
      return user;
    } catch(e) {}
  }
}

enum RegisterMode {
  Facebook,
  Email,
  Anonymous
}
