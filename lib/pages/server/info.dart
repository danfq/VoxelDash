import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:voxeldash/util/anim/handler.dart';
import 'package:voxeldash/util/data/api.dart';
import 'package:voxeldash/util/widgets/buttons.dart';
import 'package:voxeldash/util/widgets/main.dart';

class ServerInfo extends StatelessWidget {
  const ServerInfo({
    super.key,
    required this.server,
    required this.isBedrock,
  });

  ///Server
  final String server;

  ///Bedrock
  final bool isBedrock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(title: const Text("Server Info")),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Animation
            Center(child: AnimHandler.asset(animation: "server")),

            //Server Data
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: FutureBuilder(
                    future: API.serverData(
                      type: isBedrock ? ServerType.bedrock : ServerType.java,
                      server: server,
                    ),
                    builder: (context, snapshot) {
                      //Connection State
                      if (snapshot.connectionState == ConnectionState.done) {
                        //Data
                        final data = snapshot.data;

                        //Check Data
                        if (data != null) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                //Online Status
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

                                //Hostname
                                ListTile(
                                  title: const Text("Hostname"),
                                  trailing: Text(data.hostname),
                                ),

                                //Port
                                ListTile(
                                  title: const Text("Port"),
                                  trailing: Text(data.port.toString()),
                                ),

                                //Minecraft Version
                                ListTile(
                                  title: const Text("Version"),
                                  trailing: Text(data.version),
                                ),

                                //Software
                                ListTile(
                                  title: const Text("Software"),
                                  trailing: Text(data.software),
                                ),

                                //Game Mode
                                ListTile(
                                  title: const Text("Game Mode"),
                                  trailing: Text(data.gameMode),
                                ),

                                //Server ID
                                ListTile(
                                  title: const Text("Server ID"),
                                  trailing: Text(data.serverID),
                                ),

                                //EULA Blocked
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

                                //MOTD
                                ListTile(
                                  title: const Text("MOTD"),
                                  trailing: HtmlWidget(data.motd),
                                ),

                                //Players
                                ListTile(
                                  title: const Text("Players"),
                                  trailing: Text(
                                    "${data.players.length} / ${data.maxPlayers}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),

                                //Plugins
                                ListTile(
                                  title: const Text("Plugins"),
                                  trailing: Text(
                                    "${data.plugins.length}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),

                                //Mods
                                ListTile(
                                  title: const Text("Mods"),
                                  trailing: Text(
                                    "${data.mods.length}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          //Failed to Get Data
                          return const Center(
                            child: Text(
                              "Failed to Get Data\nMaybe Try Again?",
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      } else {
                        //Loading
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
