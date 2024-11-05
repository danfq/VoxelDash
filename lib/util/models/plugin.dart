///Plugin Data
class PluginData {
  ///Name
  final String name;

  ///Version
  final String version;

  ///Plugin Data
  PluginData({required this.name, required this.version});

  ///`PluginData` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "version": version,
    };
  }

  ///JSON Object to `PluginData`
  factory PluginData.fromJSON(Map<String, dynamic> json) {
    return PluginData(
      name: json["name"] ?? "Unknown",
      version: json["version"] ?? "Unknown",
    );
  }
}
