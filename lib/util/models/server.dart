import 'package:voxeldash/util/models/mod.dart';
import 'package:voxeldash/util/models/player.dart';
import 'package:voxeldash/util/models/plugin.dart';

///Server Data
class ServerData {
  ///Hostname
  final String hostname;

  ///IP
  final String ip;

  ///Port
  final int port;

  ///Online Status
  final bool online;

  ///Version
  final String version;

  ///Icon
  final String icon;

  ///Software
  final String software;

  ///Game Mode - Bedrock
  final String gameMode;

  ///Server ID - Bedrock
  final String serverID;

  ///EULA Blocked - Java
  final bool eulaBlocked;

  ///MOTD - HTML
  final String motd;

  ///Players - List
  final List<PlayerData> players;

  ///Max Players
  final int maxPlayers;

  ///Plugins
  final List<PluginData> plugins;

  ///Mods
  final List<ModData> mods;

  ///Server Data
  ServerData({
    required this.hostname,
    required this.ip,
    required this.port,
    required this.online,
    required this.version,
    required this.icon,
    required this.software,
    required this.gameMode,
    required this.serverID,
    required this.eulaBlocked,
    required this.motd,
    required this.players,
    required this.maxPlayers,
    required this.plugins,
    required this.mods,
  });

  ///`ServerData` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "hostname": hostname,
      "ip": ip,
      "port": port,
      "online": online,
      "version": version,
      "icon": icon,
      "software": software,
      "gameMode": gameMode,
      "serverID": serverID,
      "eulaBlocked": eulaBlocked,
      "motd": motd,
      "players": players.map((player) => player.toJSON()).toList(),
      "maxPlayers": maxPlayers,
      "plugins": plugins.map((plugin) => plugin.toJSON()).toList(),
      "mods": mods.map((mod) => mod.toJSON()).toList(),
    };
  }

  ///JSON Object to `ServerData`
  factory ServerData.fromJSON(Map<dynamic, dynamic> json) {
    return ServerData(
      hostname: json["hostname"] ?? "Unknown",
      ip: json["ip"] ?? "Unknown",
      port: json["port"] ?? 0,
      online: json["online"] ?? false,
      version: json["version"] ?? "Unknown",
      icon: json["icon"] ?? "",
      software: json["software"] ?? "Unknown",
      gameMode: json["gameMode"] ?? "Unknown",
      serverID: json["serverID"] ?? "Unknown",
      eulaBlocked: json["eulaBlocked"] ?? false,
      motd: json["motd"] ?? "",
      players: (json["players"] as List? ?? [])
          .map((item) => PlayerData.fromJSON(item))
          .toList(),
      maxPlayers: json["maxPlayers"] ?? 0,
      plugins: (json["plugins"] as List? ?? [])
          .map((item) => PluginData.fromJSON(item))
          .toList(),
      mods: (json["mods"] as List? ?? [])
          .map((item) => ModData.fromJSON(item))
          .toList(),
    );
  }
}
