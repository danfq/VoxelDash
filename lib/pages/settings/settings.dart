import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:voxeldash/pages/settings/team.dart';
import 'package:voxeldash/util/themes/controller.dart';
import 'package:voxeldash/util/widgets/main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ///Current Theme
  bool _currentTheme = ThemeController.current(context: Get.context!);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Status Bar & Navigation Bar
    ThemeController.statusAndNavSettings(mode: _currentTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(title: const Text("Settings")),
      body: SafeArea(
        child: SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          physics: const BouncingScrollPhysics(),
          sections: [
            //UI
            SettingsSection(
              title: const Text("UI & Visuals"),
              tiles: [
                SettingsTile.switchTile(
                  leading: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Icon(
                      _currentTheme ? Ionicons.ios_moon : Ionicons.ios_sunny,
                    ),
                  ),
                  title: const Text("Theme Mode"),
                  initialValue: _currentTheme,
                  onToggle: (mode) {
                    //Set New Theme
                    ThemeController.setAppearance(
                      context: context,
                      mode: mode,
                    );

                    //Status & Nav
                    ThemeController.statusAndNavSettings(mode: mode);

                    //Update Theme
                    setState(() {
                      _currentTheme = mode;
                    });
                  },
                ),
              ],
            ),

            //Team & Licenses
            SettingsSection(
              title: const Text("Team & Licenses"),
              tiles: [
                //Team
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_people),
                  title: const Text("Team"),
                  onPressed: (context) => Get.to(() => Team()),
                ),

                //Licenses
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_document),
                  title: const Text("Licenses"),
                  onPressed: (context) => Get.to(
                    () => LicensePage(
                      applicationName: "Uncaught Exception",
                      applicationIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14.0),
                          child: Image.asset(
                            "assets/img/logo.png",
                            height: 100.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
