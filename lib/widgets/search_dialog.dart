import 'package:airport/controllers/flight_controller.dart';
import 'package:airport/helpers/globals.dart';
import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  SearchDialog({super.key});
  var text = "";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SearchBar(
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          search(context);
        },
        onChanged: (val) {
          text = val;
        },
        hintText: df("df_search_by_number_or_city"),
        trailing: [
          IconButton(
              onPressed: () {
                search(context);
              },
              icon: const Icon(Icons.search))
        ],
      ),
    );
  }

  void search(context) {
    Navigator.pop(context);
    FlightController.load(searchText: text);
  }
}
