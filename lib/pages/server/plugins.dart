import 'package:flutter/material.dart';
import 'package:voxeldash/util/models/plugin.dart';
import 'package:voxeldash/util/widgets/main.dart';

class ServerPlugins extends StatelessWidget {
  const ServerPlugins({super.key, required this.plugins});

  ///Plugins
  final List<PluginData> plugins;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Server Plugins"),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: plugins.length,
          itemBuilder: (context, index) {
            //Plugin
            final plugin = plugins[index];

            //UI
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(plugin.name),
                trailing: Text(plugin.version),
              ),
            );
          },
        ),
      ),
    );
  }
}
