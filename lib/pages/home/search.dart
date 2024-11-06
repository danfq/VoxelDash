import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/route_manager.dart';
import 'package:voxeldash/pages/server/info.dart';
import 'package:voxeldash/util/data/api.dart';
import 'package:voxeldash/util/widgets/buttons.dart';
import 'package:voxeldash/util/widgets/input.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  ///Search Input Controller
  final TextEditingController _searchController = TextEditingController();

  ///Bedrock Check
  bool _isBedrock = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Search Input
        Input(
          controller: _searchController,
          placeholder: "Hostname or IP",
          centerPlaceholder: true,
        ),

        //Bedrock Check
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox.adaptive(
                  value: _isBedrock,
                  onChanged: (status) {
                    setState(() {
                      _isBedrock = status ?? false;
                    });
                  },
                );
              },
            ),
            const Text("Bedrock Server"),
          ],
        ),

        //Spacing
        const SizedBox(height: 40.0),

        //Get Information
        Buttons.elevatedIcon(
          text: "Get Information",
          icon: Ionicons.ios_search_outline,
          onTap: () async {
            //Server
            final server = _searchController.text.trim();

            //Check Server
            if (server.isNotEmpty) {
              //Load Data
              Get.to(
                () => ServerInfo(
                  server: server,
                  isBedrock: _isBedrock,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
