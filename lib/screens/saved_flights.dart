import 'package:airport/helpers/globals.dart';
import 'package:airport/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SavedFlights extends StatelessWidget {
  const SavedFlights({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget>? children = GetStorage().read("savedFlights");
    children ??= [
      Center(
        child: Text(myPref("df_no_data")),
      )
    ];
    return scaffold(
      appBarText: myPref("df_saved_flights"),
      backgroundColor: Colors.black,
      body: ListView(
        children: children,
      ),
    );
  }
}
