class Player {
  String name;
  int level;
  String color;
  bool isBot;
  Player({this.name, this.level, this.color, this.isBot});
}

Map<String,Player> players = new Map<String, Player>();