import 'package:tankwar/models/user.dart';
import 'package:tankwar/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';


class DatabaseService {
  String uid;
  static final DatabaseService _instance = DatabaseService._internal();
  final CollectionReference userCollection = Firestore.instance.collection('users');
  factory DatabaseService({String uid}) {
    _instance.uid = uid;
    return _instance;
  }
  DatabaseService._internal();

  Future createUserProfile({User user, RegisterMode registerMode}) async {
    try {
      if(registerMode == RegisterMode.Facebook) {
        userCollection.document('uid_map').updateData({
          user.facebookId: user.uid
        });
      }
      userCollection.document(this.uid).get().then((snapshot) {
        if(!snapshot.exists) {
          userCollection.document(this.uid).setData({
            'displayName': user.displayName,
            'level': 1,
            'friends': user.friends,
            'photoUrl': user.photoUrl,
            'request': []
          });
        }
      });
    } catch(e) {
      print('Exception: ${e.toString()}');
    }
    return;
  }
}