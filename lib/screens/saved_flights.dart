import 'dart:io';

import 'package:airport/helpers/globals.dart';
import 'package:airport/screens/home2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/flight_controller.dart';
import '../widgets/MyWarningDialog.dart';
import '../widgets/common.dart';
import '../widgets/flight_card2.dart';

class SavedFlights extends StatefulWidget {
  SavedFlights({super.key});

  @override
  State<SavedFlights> createState() => _SavedFlightsState();
}

class _SavedFlightsState extends State<SavedFlights> {
  List? saved = GetStorage().read("saved_flights");


  @override
  Widget build(BuildContext context) {
    List<Widget> data = [];
    if (saved != null) {
      for (int i = 0; i < saved!.length; i++) {
        data.add(FlightCard2(
            isSaved: true,
            data:
                FlightController.getFlightOrDelete(id: saved![i]["flight_no"]),
            onLongPress: () async {
              await FlightController.delete(saved![i]["flight_no"]);
              setState(() {});
            }));
      }
    }
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          onPop(context);
        },
        child: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.5,
              image: AssetImage("assets/app/wallpaper.jpg"))),
      child: Directionality(
        textDirection: dirc() == "ltr" ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            title: Text(df("df_saved_flights")),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Get.offAll(() => const STable());
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          backgroundColor: Colors.black12,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                tableHeader(),
                Expanded(
                  child: ListView(
                    children: saved != null && saved!.isNotEmpty
                        ? data
                        : [
                      br(),
                      Text(
                        df("df_usage"),
                        textAlign: TextAlign.center,
                      ),
                      Image.asset(
                        "assets/images/usage.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
    );

  }
}
