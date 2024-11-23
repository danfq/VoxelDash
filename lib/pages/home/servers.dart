import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:voxeldash/pages/server/mods.dart';
import 'package:voxeldash/pages/server/players.dart';
import 'package:voxeldash/pages/server/plugins.dart';
import 'package:voxeldash/util/anim/handler.dart';
import 'package:voxeldash/util/data/api.dart';
import 'package:voxeldash/util/data/local.dart';
import 'package:voxeldash/util/models/server.dart';
import 'package:voxeldash/util/widgets/buttons.dart';

class MyServers extends StatefulWidget {
  const MyServers({super.key});

  @override
  State<MyServers> createState() => _MyServersState();
}

class _MyServersState extends State<MyServers> {
  late List<ServerData> servers;
  final Map<String, bool> _isRefreshing = {};

  @override
  void initState() {
    super.initState();
    servers = (LocalData.boxData(box: "servers")["list"] as List<dynamic>)
        .map((item) => ServerData.fromJSON(item))
        .toList();
  }

  Future<void> refreshServer(ServerData server) async {
    setState(() => _isRefreshing[server.hostname] = true);

    try {
      final refreshedServer = await API.serverData(
        type: server.isBedrock ? ServerType.bedrock : ServerType.java,
        server: server.hostname,
      );

      setState(() {
        final index = servers.indexWhere((s) => s.hostname == server.hostname);
        if (index != -1) {
          servers[index] = refreshedServer;
          final List<dynamic> storedServers =
              servers.map((s) => s.toJSON()).toList();
          LocalData.updateValue(
            box: "servers",
            item: "list",
            value: storedServers,
          );
        }
      });
    } catch (e) {
      debugPrint("Error refreshing server: $e");
    } finally {
      setState(() => _isRefreshing[server.hostname] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // List
    return servers.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: servers.length,
              itemBuilder: (context, index) {
                // Server
                final server = servers[index];

                // UI
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      //Delete
                      Center(
                        child: Buttons.elevatedIcon(
                          icon: Ionicons.ios_trash_outline,
                          text: "Remove",
                          onTap: () async {
                            //Confirmation
                            await Get.defaultDialog(
                              title: "Remove Server?",
                              middleText:
                                  "This Server will be removed from your Servers.",
                              cancel: Buttons.text(
                                text: "Cancel",
                                onTap: () => Get.back(),
                              ),
                              confirm: Buttons.elevated(
                                text: "Remove",
                                onTap: () async {
                                  //Remove From List
                                  setState(() {
                                    servers.removeAt(index);
                                  });

                                  //Remove Locally
                                  await API.removeServer(
                                    hostname: server.hostname,
                                  );

                                  //Close Dialog
                                  Get.back();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Stack(
                      children: [
                        ExpansionTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimHandler.asset(animation: "server"),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          title: Text(server.hostname),
                          subtitle: Text("Version: ${server.version}"),
                          children: [
                            // Refresh button
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, top: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Buttons.elevatedIcon(
                                  text: _isRefreshing[server.hostname] == true
                                      ? ""
                                      : "Refresh",
                                  icon: Ionicons.ios_refresh_outline,
                                  onTap: () async =>
                                      await refreshServer(server),
                                ),
                              ),
                            ),
                            // Online status
                            ListTile(
                              title: const Text("Online"),
                              trailing: Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      server.online ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            // Hostname
                            ListTile(
                              title: const Text("Hostname"),
                              trailing: Text(server.hostname),
                            ),
                            // Port
                            ListTile(
                              title: const Text("Port"),
                              trailing: Text(server.port.toString()),
                            ),
                            // Version
                            ListTile(
                              title: const Text("Version"),
                              trailing: Text(server.version),
                            ),
                            // Software
                            ListTile(
                              title: const Text("Software"),
                              trailing: Text(server.software),
                            ),
                            // Game Mode
                            ListTile(
                              title: const Text("Game Mode"),
                              trailing: Text(server.gameMode),
                            ),
                            // Server ID
                            ListTile(
                              title: const Text("Server ID"),
                              trailing: Text(server.serverID),
                            ),
                            // EULA Blocked Status
                            ListTile(
                              title: const Text("EULA Blocked"),
                              trailing: Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: server.eulaBlocked
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                if (server.players.isNotEmpty) {
                                  Get.to(() =>
                                      ServerPlayers(players: server.players));
                                }
                              },
                              title: const Text("Players"),
                              trailing: Text(
                                "${server.players.length} / ${server.maxPlayers}",
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                if (server.plugins.isNotEmpty) {
                                  Get.to(() =>
                                      ServerPlugins(plugins: server.plugins));
                                }
                              },
                              title: const Text("Plugins"),
                              trailing: Text("${server.plugins.length}"),
                            ),
                            ListTile(
                              onTap: () {
                                if (server.mods.isNotEmpty) {
                                  Get.to(() => ServerMods(mods: server.mods));
                                }
                              },
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(14.0),
                                  bottomRight: Radius.circular(14.0),
                                ),
                              ),
                              title: const Text("Mods"),
                              trailing: Text("${server.mods.length}"),
                            ),
                          ],
                        ),
                        if (_isRefreshing[server.hostname] == true)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: AnimHandler.asset(animation: "empty"),
          );
  }
}
