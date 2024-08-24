import 'dart:async';

import 'package:airport/controllers/flight_controller.dart';
import 'package:airport/screens/saved_flights.dart';
import 'package:airport/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import '../widgets/common.dart';

/*class STable extends StatelessWidget {
  const STable({super.key});

  @override
  Widget build(BuildContext context) {
    return scaffold(
        backgroundColor: Colors.black,
        appBarText: "dd",
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                border: TableBorder.all(color: Colors.white24),
                children: List.generate(
                    FlightController.departure.value['2024-08-22'].length,
                        (index) => fn(FlightController.departure.value['2024-08-22']
                    [index]))),
          ),
        ));
  }

  fn(Map data) {
    return TableRow(
      children: [
        Text(style: colorStyle(isSmall: true), data["normal_time"]),
        Text(style: colorStyle(isSmall: true), data['country_name']),
        Text(style: colorStyle(isSmall: true), data["city_name"]),
        //Text(style: colorStyle(isSmall: true), data["VIA"]),
        //Text(style: colorStyle(isSmall: true), data['_path']),
        Text(style: colorStyle(isSmall: true), data["status"]),
        Text(style: colorStyle(isSmall: true), data["estmtd_real_time"]),
      ],
    );
  }
}*/

class STable extends StatefulWidget {
  const STable({super.key});

  @override
  State<STable> createState() => _HomeState();
}

class _HomeState extends State<STable> {
  final formKey = GlobalKey<FormState>();
  late final List<Widget> bodies;

  @override
  void initState() {
    super.initState();
    startPeriodicFunction();
    bodies = [
      arrival(),
      departure(),
    ];
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Text> tabs = [];
    for (var date in FlightController.dates) {
      tabs.add(Text(date['STM_DATE']));
    }

    return DefaultTabController(
      length: FlightController.dates.length,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: SettingsController.themeColor.withOpacity(0.7),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SearchDialog(),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
            title: Text(
              myPref("df_flight_info"),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: refresh, icon: const Icon(Icons.refresh)),
              IconButton(
                  onPressed: () async {
                    await SettingsController.changeLanguage();
                    await refresh();
                  },
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                  ))
            ],
            bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 10),
                child: TabBar(tabs: tabs))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: bodies[selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: SettingsController.themeColor,
          type: BottomNavigationBarType.fixed,
// Ensures all items are visible
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          selectedItemColor: Colors.white,
// Highlighted tab color
          unselectedItemColor: Colors.grey,
// Unselected tab color
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
// Bold text for selected item
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.flight_land_rounded,
                size: 20,
              ),
              label: myPref('df_arrival'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.flight_takeoff_rounded,
                size: 20,
              ),
              label: myPref('df_departure'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => SavedFlights());
          },
          child: const Icon(
            Icons.favorite,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    await FlightController.load();
  }

  void startPeriodicFunction() {
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      await FlightController.load();
    });
  }

  Widget arrival() {
    List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      list.add(Obx(() {
        var arrival = FlightController.arrival.value;
        var flights = arrival[date];

        if (flights == null || flights.length == 0) {
          return Center(
            child: Text(myPref("df_no_data")),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return flightCard2(
                data: flights[index],
              );
            },
            itemCount: flights.length,
          );
        }
      }));
    }
    return TabBarView(children: list);
  }

  Widget departure() {
    List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      list.add(Obx(() {
        var flights;
        var departure = FlightController.departure.value;
        if (departure.containsKey(date)) {
          flights = departure?[date];
        }
        if (flights == null || flights.length == 0) {
          return Center(
            child: Text(myPref("df_no_data")),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return flightCard2(
                data: flights[index],
              );
            },
            itemCount: flights.length,
          );
        }
      }));
    }
    return TabBarView(children: list);
  }

  Widget flightCard2({var data}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
                    style: colorStyle(isSmall: true),
                    "${data["normal_time"]}")),
            Expanded(
                child: Text(
                    style: colorStyle(isSmall: true),
                    "${data['country_name']}")),
            Expanded(
                child: Text(
                    style: colorStyle(isSmall: true), "${data["city_name"]}")),
            // Expanded(child: Text(style: colorStyle(isSmall: true), data["VIA"])),
            // Expanded(child: Text(style: colorStyle(isSmall: true), data['_path'])),
            Expanded(
                child: Text(
                    style: colorStyle(isSmall: true), '${data["status"]}')),
            Expanded(
                child: Text(
                    style: colorStyle(isSmall: true),
                    "${data["estmtd_real_time"]}")),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
// make the api return data sperated by the day
//X fix the arabic and store it if it arabic get the arabic data
//X make the search page and the related api
