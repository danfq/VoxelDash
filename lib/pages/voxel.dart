import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:voxeldash/pages/home/search.dart';
import 'package:voxeldash/pages/home/servers.dart';
import 'package:voxeldash/pages/settings/settings.dart';
import 'package:voxeldash/util/widgets/buttons.dart';
import 'package:voxeldash/util/widgets/main.dart';

class VoxelDash extends StatefulWidget {
  const VoxelDash({super.key});

  @override
  State<VoxelDash> createState() => _VoxelDashState();
}

class _VoxelDashState extends State<VoxelDash> {
  ///Navigation Index
  int _navIndex = 0;

  ///Navigation Body
  Widget _navBody() {
    switch (_navIndex) {
      //Home
      case 0:
        return SearchPage();

      //My Servers
      case 1:
        return const MyServers();

      //Default - None
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        centerTitle: false,
        allowBack: false,
        title: const Text("VoxelDash"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Buttons.icon(
              icon: Ionicons.ios_settings_outline,
              onTap: () => Get.to(() => const Settings()),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _navBody()),
      bottomNavigationBar: MainWidgets.bottomNav(
        navIndex: _navIndex,
        onChanged: (index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
    );
  }
}
