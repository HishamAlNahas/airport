import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controllers/flight_controller.dart';
import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import '../widgets/flight_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                onPressed: () {},
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
        body: bodies[selectedIndex],
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
      ),
    );
  }

  void startPeriodicFunction() {
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      await refresh();
    });
  }

  Future<void> refresh() async {
    await FlightController.load();
  }

  Widget arrival() {
    List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      list.add(Obx(() {
        var arrival = FlightController.arrival.value;
        var flights = arrival[date];

        if (flights == null || flights.length == 0) {
          return const Center(
            child: Text("No Data"),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return FlightCard(
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
          return const Center(
            child: Text("No Data"),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return FlightCard(
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
}
// make the api return data sperated by the day
//X fix the arabic and store it if it arabic get the arabic data
// make the search page and the related api
