class Player {
  String username;
  String pictureKey;
  String pictureName;
  String color;

  Player({required this.username, required this.pictureKey, required this.pictureName, required this.color});

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        username: json['username']!,
        pictureKey: json['picture']['key']!,
        pictureName: json['picture']['name']!,
        color: json['color']!,
    );

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'color': color,
      'picture': {
        'key': pictureKey,
        'name': pictureName,
      }
    };
  }

  @override
  String toString() =>
      'Player { username: $username, pictureKey: $pictureKey, pictureName: $pictureName, color: $color }';
}