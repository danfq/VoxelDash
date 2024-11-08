import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:voxeldash/util/data/local.dart';
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

  ///Retry Options
  static const _retryOptions = RetryOptions(maxAttempts: 5);

  ///Get Server Data
  ///
  ///Requires:
  ///- `type` - Can be JAVA or BEDROCK.
  ///- `server` - Can be a Hostname or IP (Port Not Necessary).
  static Future<ServerData> serverData({
    required ServerType type,
    required String server,
  }) async {
    //Request
    final request = await _retryOptions.retry(
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

    //Parse Players Data with Skin URLs
    final players = await Future.wait(
      (data["players"]?["list"] as List?)
              ?.map<Future<PlayerData>>((item) async {
            final uuid = item["uuid"];
            final username = item["name"];

            //Fetch Skin URL
            final skinURL = uuid != null ? await _playerSkin(uuid) : null;

            //Return Player Data
            return PlayerData(
              uuid: uuid,
              username: username,
              skinURL: skinURL ?? "",
            );
          }).toList() ??
          <Future<PlayerData>>[],
    );

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
      players: players,
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

  ///Save Server
  static Future<void> saveServer({required ServerData server}) async {
    //Saved Servers
    final List<dynamic> servers =
        LocalData.boxData(box: "servers")["list"] ?? [];

    //Check for Same Hostname
    final bool serverExists = servers.any((savedServer) =>
        savedServer is Map<String, dynamic> &&
        savedServer["hostname"] == server.hostname);

    //Check if Server is Already Present
    if (serverExists) {
      //Notify User
      LocalNotif.show(
        title: "Hmm...",
        message: "'${server.hostname} Already Saved'",
      );
    } else {
      //Add Server to List
      servers.add(server.toJSON());

      //Update List
      await LocalData.setData(box: "servers", data: {"list": servers});

      //Notify User
      LocalNotif.show(
        title: "Server Saved",
        message: "The server '${server.hostname}' has been successfully added.",
      );
    }
  }

  ///Remove Server
  static Future<void> removeServer({required String hostname}) async {
    //Servers
    final List<dynamic> servers =
        LocalData.boxData(box: "servers")["list"] ?? [];

    //Remove Server
    servers.removeWhere((item) => item["hostname"] == hostname);

    //Update Servers
    await LocalData.updateValue(
      box: "servers",
      item: "list",
      value: servers,
    );

    //Notify User
    LocalNotif.show(title: "Done!", message: "Server Removed!");
  }

  ///Fetch Player Skin URL based on UUIS
  static Future<String?> _playerSkin(String uuid) async {
    try {
      //Request
      final response = await _retryOptions.retry(
        () => http.get(
          Uri.parse("https://crafatar.com/renders/body/$uuid"),
        ),
      );

      //Check for Success
      if (response.statusCode == 200) {
        //Return Skin URL
        return "https://crafatar.com/renders/body/$uuid";
      } else {
        debugPrint("Failed to Fetch Player Profile: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("Error Fetching Player Skin URL: $error.");
    }

    //Return Null by Default
    return null;
  }
}
