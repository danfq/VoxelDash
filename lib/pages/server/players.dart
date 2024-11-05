import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:voxeldash/util/models/player.dart';
import 'package:voxeldash/util/widgets/buttons.dart';
import 'package:voxeldash/util/widgets/main.dart';

class ServerPlayers extends StatefulWidget {
  const ServerPlayers({super.key, required this.players});

  ///Players
  final List<PlayerData> players;

  @override
  State<ServerPlayers> createState() => _ServerPlayersState();
}

class _ServerPlayersState extends State<ServerPlayers>
    with SingleTickerProviderStateMixin {
  ///Player Expanded States
  final Map<int, bool> _expandedState = {};
  final Map<int, AnimationController> _controllers = {};

  @override
  void dispose() {
    //Dispose Controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Server Players"),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.players.length,
          itemBuilder: (context, index) {
            //Player
            final player = widget.players[index];

            //Expanded State
            final isExpanded = _expandedState[index] ?? false;

            //Initialize Controller if Not Present
            _controllers.putIfAbsent(
              index,
              () => AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 200),
              ),
            );

            //Animation on Expand
            if (isExpanded) {
              _controllers[index]!.forward();
            } else {
              _controllers[index]!.reverse();
            }

            //UI
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Column(
                  children: [
                    //User Data
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      leading: const Icon(Ionicons.ios_person),
                      title: Text(
                        player.username,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isExpanded ? 0.25 : 0,
                        child: Buttons.iconFilled(
                          icon: Ionicons.ios_chevron_forward,
                          onTap: () {
                            setState(() {
                              _expandedState[index] = !isExpanded;
                            });
                          },
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _expandedState[index] = !isExpanded;
                        });
                      },
                    ),

                    //Content
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: _controllers[index]!,
                        curve: Curves.easeOut,
                      ),
                      child: Column(
                        children: [
                          //UUID
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: const Text("UUID"),
                              trailing: Text(player.uuid),
                            ),
                          ),

                          //Skin
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.network(
                              player.skinURL,
                              height: 240.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
