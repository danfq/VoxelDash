import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:voxeldash/pages/server/mods.dart';
import 'package:voxeldash/pages/server/players.dart';
import 'package:voxeldash/pages/server/plugins.dart';
import 'package:voxeldash/util/anim/handler.dart';
import 'package:voxeldash/util/data/local.dart';
import 'package:voxeldash/util/models/server.dart';

class MyServers extends StatelessWidget {
  const MyServers({super.key});

  @override
  Widget build(BuildContext context) {
    // Servers
    final List<dynamic> servers =
        (LocalData.boxData(box: "servers")["list"] ?? [])
            .map((item) => ServerData.fromJSON(item))
            .toList();

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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.0),
                    splashColor: Theme.of(context).splashColor,
                    onTap: null, // Prevents InkWell from being triggered on tap
                    child: ExpansionTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimHandler.asset(animation: "server"),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      title: Text(server.hostname),
                      subtitle: Text("Version: ${server.version}"),
                      children: [
                        // Online status
                        ListTile(
                          title: const Text("Online"),
                          trailing: Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: server.online ? Colors.green : Colors.red,
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
                              Get.to(
                                  () => ServerPlayers(players: server.players));
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
                              Get.to(
                                  () => ServerPlugins(plugins: server.plugins));
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
                  ),
                );
              },
            ),
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimHandler.asset(animation: "empty", reverse: true),
                const Text("You Have No Servers"),
              ],
            ),
          );
  }
}
