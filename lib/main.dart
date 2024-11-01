import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:voxeldash/pages/voxel.dart';
import 'package:voxeldash/util/handlers/network.dart';
import 'package:voxeldash/util/themes/themes.dart';

void main() {
  //Run App
  runApp(
    AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: AdaptiveThemeMode.system,
      builder: (light, dark) {
        return GetMaterialApp(
          theme: light,
          darkTheme: dark,
          home: const VoxelDash(),
        );
      },
    ),
  );
}
