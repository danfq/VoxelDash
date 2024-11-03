import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:voxeldash/util/handlers/local_notif.dart';
import 'package:voxeldash/util/models/mod.dart';
import 'package:voxeldash/util/models/player.dart';
import 'package:voxeldash/util/models/plugin.dart';
import 'package:voxeldash/util/models/server.dart';

///Type
enum ServerType { java, bedrock }

///API Handler
class API {
  ///Java Endpoint
  static const String _javaEndpoint = "https://api.mcsrvstat.us/3";

  ///Bedrock Endpoint
  static const String _bedrockEndpoint = "https://api.mcsrvstat.us/bedrock/3";

  ///Get Server Data
  ///
  ///Requires:
  ///- `type` - Can be JAVA or BEDROCK.
  ///- `server` - Can be a Hostname or IP (Port Not Necessary).
  static Future<ServerData> serverData({
    required ServerType type,
    required String server,
  }) async {
    //Retry Options
    const retryOptions = RetryOptions(maxAttempts: 5);

    //Request
    final request = await retryOptions.retry(
      () => http.get(
        Uri.parse(
          type == ServerType.bedrock
              ? "$_bedrockEndpoint/$server"
              : "$_javaEndpoint/$server",
        ),
      ),
      retryIf: (error) => error is SocketException || error is TimeoutException,
      onRetry: (error) {
        //Notify
        LocalNotif.show(
          title: "Uh-oh!",
          message: "An error occurred. Retrying...",
        );

        //Debug
        debugPrint(error.toString());
      },
    );

    //Check Response Code
    if (request.statusCode != 200) {
      //Notify
      LocalNotif.show(
        title: "Uh-oh!",
        message: "Error: ${request.statusCode}.",
      );
    }

    //Response Data
    final Map<String, dynamic> data = jsonDecode(request.body);

    //Parse Data
    final parsedData = ServerData(
      hostname: data["hostname"] ?? "Undetermined",
      ip: data["ip"] ?? "Undetermined",
      port: data["port"] ?? 0,
      online: data["online"],
      version: data["version"] ?? "Undetermined",
      icon: data["icon"] ?? "",
      software: data["software"] ?? "Unspecified",
      gameMode: data["gamemode"] ?? "Not Bedrock",
      serverID: data["serverid"] ?? "Not Bedrock",
      eulaBlocked: data["eula_blocked"] ?? false,
      motd: data["motd"]?["html"][0] ?? "Undetermined",
      players: (data["players"]?["list"] as List?)?.map<PlayerData>((item) {
            //Player Data
            final playerData = PlayerData(
              uuid: item["uuid"],
              username: item["name"],
            );

            //Return Player Data
            return playerData;
          }).toList() ??
          <PlayerData>[],
      maxPlayers: data["players"]?["max"] ?? 0,
      plugins: (data["plugins"] as List?)?.map<PluginData>((item) {
            //Plugin Data
            final pluginData = PluginData(
              name: item["name"],
              version: item["version"],
            );

            //Return Plugin Data
            return pluginData;
          }).toList() ??
          <PluginData>[],
      mods: (data["mods"] as List?)?.map<ModData>((item) {
            //Mod Data
            final modData = ModData(
              name: item["name"],
              version: item["version"],
            );

            //Return Mod Data
            return modData;
          }).toList() ??
          <ModData>[],
    );

    //Return Server Data
    return parsedData;
  }
}
