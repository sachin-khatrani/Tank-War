class User {
  final String uid;
  final String displayName;
  final String photoUrl;
  final int level;
  List<String> friends;
  String facebookId;
  static User _instance;
  factory User({var uid, var displayName, var photoUrl, var level, var friends}){
    if(_instance == null)
      _instance = User._create(uid, displayName, photoUrl, level, friends);
    return _instance;
  }

  User._create(this.uid, this.displayName, this.photoUrl, this.level, this.friends);

}




