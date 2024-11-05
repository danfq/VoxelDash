import 'package:flutter/material.dart';
import 'package:voxeldash/util/models/mod.dart';
import 'package:voxeldash/util/widgets/main.dart';

class ServerMods extends StatelessWidget {
  const ServerMods({super.key, required this.mods});

  ///Mods
  final List<ModData> mods;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Server Mods"),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: mods.length,
          itemBuilder: (context, index) {
            //Mod
            final mod = mods[index];

            //UI
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(mod.name),
                trailing: Text(mod.version),
              ),
            );
          },
        ),
      ),
    );
  }
}
