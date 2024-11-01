import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(
    AdaptiveTheme(
      light: light,
      dark: dark,
      initial: AdaptiveThemeMode.system,
      builder: (light, dark) {
        return GetMaterialApp(
          theme: light,
          darkTheme: dark,
          home: ,
        );
      },
    ),
  );
}
