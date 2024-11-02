import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:voxeldash/pages/voxel.dart';
import 'package:voxeldash/util/anim/handler.dart';
import 'package:voxeldash/util/data/local.dart';

class Intro extends StatelessWidget {
  Intro({super.key});

  //Pages
  final _pages = [
    //Welcome
    PageViewModel(
      image: AnimHandler.asset(animation: "hello"),
      title: "Welcome to VoxelDash!",
      body: "Your one-stop App for managing Minecraft Servers!",
    ),

    //Manage Servers
    PageViewModel(
      image: AnimHandler.asset(animation: "list"),
      title: "Manage Servers With Ease",
      body: "Add an infinite amount of Servers",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: _pages,
          showNextButton: true,
          showBackButton: true,
          showDoneButton: true,
          showSkipButton: false,
          next: const Text("Next"),
          back: const Text("Back"),
          done: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onDone: () async {
            //Set Intro as Done
            await LocalData.updateValue(
              box: "intro",
              item: "status",
              value: true,
            );

            //Go Home
            Get.to(() => const VoxelDash());
          },
        ),
      ),
    );
  }
}
