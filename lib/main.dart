import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:voxeldash/pages/voxel.dart';
import 'package:voxeldash/util/handlers/main.dart';
import 'package:voxeldash/util/themes/themes.dart';

void main() async {
  //Initialize Services
  await MainHandler.init();

  //Initial Route
  final initialRoute = MainHandler.initialRoute();

  //Run App
  runApp(
    ToastificationWrapper(
      child: AdaptiveTheme(
        light: Themes.light,
        dark: Themes.dark,
        initial: AdaptiveThemeMode.system,
        builder: (light, dark) {
          return GetMaterialApp(
            theme: light,
            darkTheme: dark,
            home: initialRoute,
          );
        },
      ),
    ),
  );
}
