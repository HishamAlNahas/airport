import 'package:airport/helpers/globals.dart';
import 'package:airport/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/common.dart';

class SavedFlights extends StatefulWidget {
  SavedFlights({super.key});

  @override
  State<SavedFlights> createState() => _SavedFlightsState();
}

class _SavedFlightsState extends State<SavedFlights> {
  List? saved = GetStorage().read("savedFlights");

  @override
  Widget build(BuildContext context) {
    List<Widget>? children;
    if (saved != null) {
      children = List.generate(
        saved!.length,
        (index) => flightCard2(
            data: saved![index],
            onLongPress: () {
              delete(index);
            }),
      );
    }

    children ??= [
      Center(
        child: Text(myPref("df_no_data")),
      )
    ];
    return scaffold(
      appBarText: myPref("df_saved_flights"),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            flightCard2(data: {
              "normal_time": myPref("df_time"),
              'country_name': myPref("df_country"),
              "city_name": myPref("df_city"),
              "status": myPref("df_status")
            }),
            Expanded(
              child: ListView(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void delete(index) {
    toast(
        title: myPref("df_deleted"),
        message: myPref("df_deleted_message"),
        customColor: Colors.black);
    saved!.removeAt(index);
    setState(() {});
  }
}
