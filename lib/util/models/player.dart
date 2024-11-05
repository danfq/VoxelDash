///Player Data
class PlayerData {
  ///UUID
  final String uuid;

  ///Username
  final String username;

  ///Skin
  final String skinURL;

  ///PlayerData
  PlayerData({
    required this.uuid,
    required this.username,
    required this.skinURL,
  });

  ///`PlayerData` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "uuid": uuid,
      "username": username,
      "skinURL": skinURL,
    };
  }

  ///JSON Object to `PlayerData`
  factory PlayerData.fromJSON(Map<String, dynamic> json) {
    return PlayerData(
      uuid: json["uuid"] ?? "Unknown",
      username: json["username"] ?? "Unknown",
      skinURL: json["skinURL"] ?? "",
    );
  }
}
