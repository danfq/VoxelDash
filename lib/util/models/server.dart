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
}
