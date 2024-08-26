import 'package:airport/helpers/globals.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/flight_controller.dart';
import '../widgets/common.dart';

class SavedFlights extends StatefulWidget {
  SavedFlights({super.key});

  @override
  State<SavedFlights> createState() => _SavedFlightsState();
}

class _SavedFlightsState extends State<SavedFlights> {
  List? saved = GetStorage().read("saved_flights");

  @override
  Widget build(BuildContext context) {
    /*List<Widget>? children;
    if (saved != null) {
      children = List.generate(
        saved!.length,
        (index) => flightCard2(
            data: saved![index],
            onLongPress: () {
              delete(index);
            }),
      );
    }*/
    List<Widget> data = [];
    if (saved != null) {
      for (int i = 0; i < saved!.length; i++) {
        print(" saved![i]['flight_no'] ${saved![i]["flight_no"]}");
        data.add(flightCard2(
            data:
                FlightController.getFlightOrDelete(id: saved![i]["flight_no"]),
            onLongPress: () {
              delete(i);
            }));
      }
    }

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.5,
              image: AssetImage("assets/app/wallpaper.jpg"))),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(df("df_saved_flights")),
          centerTitle: true,
        ),
        backgroundColor: Colors.black12,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              flightCard2(data: {
                "normal_time": df("df_time"),
                'city_name': df("df_city"),
                "flight_no": df("df_flight_no"),
                "status": df("df_status")
              }),
              Expanded(
                child: ListView(
                  children: saved != null
                      ? data
                      : [
                          Center(
                            child: Text(df("df_no_data")),
                          )
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void delete(index) {
    toast(
        title: df("df_deleted"),
        message: df("df_deleted_message"),
        customColor: Colors.black);
    saved!.removeAt(index);
    setState(() {});
  }
}
