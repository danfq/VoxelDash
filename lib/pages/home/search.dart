import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:voxeldash/util/widgets/buttons.dart';
import 'package:voxeldash/util/widgets/input.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  ///Search Input Controller
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Search Input
        Input(
          controller: _searchController,
          placeholder: "Search...",
        ),

        //Information
        Text(
          "You can enter a HostName or an IP.\nA Port isn't necessary.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        //Spacing
        const SizedBox(height: 40.0),

        //Get Information
        Buttons.elevatedIcon(
          text: "Get Information",
          icon: Ionicons.ios_search_outline,
          onTap: () {},
        ),
      ],
    );
  }
}
