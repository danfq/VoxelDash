import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/route_manager.dart';
import 'package:voxeldash/pages/server/mods.dart';
import 'package:voxeldash/pages/server/players.dart';
import 'package:voxeldash/pages/server/plugins.dart';
import 'package:voxeldash/util/anim/handler.dart';
import 'package:voxeldash/util/data/api.dart';
import 'package:voxeldash/util/models/server.dart';
import 'package:voxeldash/util/widgets/buttons.dart';
import 'package:voxeldash/util/widgets/main.dart';

class ServerInfo extends StatefulWidget {
  const ServerInfo({
    super.key,
    required this.server,
    required this.isBedrock,
  });

  /// Server
  final String server;

  /// Bedrock
  final bool isBedrock;

  @override
  State<StatefulWidget> createState() => _ServerInfoState();
}

class _ServerInfoState extends State<ServerInfo> {
  bool _showSaveButton = false;
  Future<ServerData>? _serverDataFuture;

  @override
  void initState() {
    super.initState();
    _serverDataFuture = _fetchServerData();
  }

  Future<ServerData> _fetchServerData() async {
    final data = await API.serverData(
      type: widget.isBedrock ? ServerType.bedrock : ServerType.java,
      server: widget.server,
    );
    setState(() {
      _showSaveButton = true;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Server Info"),
        actions: [
          AnimatedOpacity(
            opacity: _showSaveButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Buttons.icon(
                icon: Ionicons.ios_star_outline,
                onTap: () {
                  Get.defaultDialog(
                    barrierDismissible: false,
                    title: "Save Server?",
                    content: Text(
                      "Would you like to save this Server?",
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    titleStyle: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                    cancel: Buttons.text(
                      text: "No",
                      onTap: () => Get.back(),
                    ),
                    confirm: Buttons.elevated(
                      text: "Save",
                      onTap: () async {
                        Get.back();
                        final serverData = await _serverDataFuture;
                        await API.saveServer(server: serverData!);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: AnimHandler.asset(animation: "server")),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: FutureBuilder<ServerData>(
                    future: _serverDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final data = snapshot.data;
                        if (data != null) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text("Online"),
                                  trailing: Container(
                                    height: 10.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: data.online
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Hostname"),
                                  trailing: Text(data.hostname),
                                ),
                                ListTile(
                                  title: const Text("Port"),
                                  trailing: Text(data.port.toString()),
                                ),
                                ListTile(
                                  title: const Text("Version"),
                                  trailing: Text(data.version),
                                ),
                                ListTile(
                                  title: const Text("Software"),
                                  trailing: Text(data.software),
                                ),
                                ListTile(
                                  title: const Text("Game Mode"),
                                  trailing: Text(data.gameMode),
                                ),
                                ListTile(
                                  title: const Text("Server ID"),
                                  trailing: Text(data.serverID),
                                ),
                                ListTile(
                                  title: const Text("EULA Blocked"),
                                  trailing: Container(
                                    height: 10.0,
                                    width: 10.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: data.eulaBlocked
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: const Text("MOTD"),
                                  trailing: HtmlWidget(data.motd),
                                ),
                                ListTile(
                                  onTap: () {
                                    if (data.players.isNotEmpty) {
                                      Get.to(() =>
                                          ServerPlayers(players: data.players));
                                    }
                                  },
                                  title: const Text("Players"),
                                  trailing: Text(
                                    "${data.players.length} / ${data.maxPlayers}",
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    if (data.plugins.isNotEmpty) {
                                      Get.to(() =>
                                          ServerPlugins(plugins: data.plugins));
                                    }
                                  },
                                  title: const Text("Plugins"),
                                  trailing: Text("${data.plugins.length}"),
                                ),
                                ListTile(
                                  onTap: () {
                                    if (data.mods.isNotEmpty) {
                                      Get.to(() => ServerMods(mods: data.mods));
                                    }
                                  },
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(14.0),
                                      bottomRight: Radius.circular(14.0),
                                    ),
                                  ),
                                  title: const Text("Mods"),
                                  trailing: Text("${data.mods.length}"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Failed to Get Data\nMaybe Try Again?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
