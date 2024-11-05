///Mod Data
class ModData {
  ///Name
  final String name;

  ///Version
  final String version;

  ///Mod Data
  ModData({required this.name, required this.version});

  ///`ModData` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "version": version,
    };
  }

  ///JSON Object to `ModData`
  factory ModData.fromJSON(Map<String, dynamic> json) {
    return ModData(
      name: json["name"] ?? "Unknown",
      version: json["version"] ?? "Unknown",
    );
  }
}
