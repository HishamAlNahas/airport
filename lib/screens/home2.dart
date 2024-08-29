import 'dart:async';

import 'package:airport/controllers/flight_controller.dart';
import 'package:airport/screens/saved_flights.dart';
import 'package:airport/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import '../widgets/common.dart';

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
    startPeriodicRefresh();
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
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.5,
              image: AssetImage("assets/app/wallpaper.jpg"))),
      child: DefaultTabController(
        length: FlightController.dates.length,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              //backgroundColor: SettingsController.themeColor.withOpacity(0.7),
              backgroundColor: Colors.black26,
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
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/app/logo.png",
                    width: 45,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          df("df_title"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          df("df_subtitle"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
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
                  preferredSize: const Size(double.infinity, 30),
                  child: TabBar(tabs: tabs))),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                tableHeader(),
                Expanded(child: bodies[selectedIndex]),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: SettingsController.themeColor.withOpacity(0.6),
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
                label: df('df_arrival'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.flight_takeoff_rounded,
                  size: 20,
                ),
                label: df('df_departure'),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              Get.to(() => SavedFlights());
            },
            child: const Icon(
              Icons.bookmark_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    await FlightController.load();
  }

  void startPeriodicRefresh() {
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      await FlightController.load();
    });
  }

  Widget arrival() {
    return Obx(() => flightsList(FlightController.arrival.value));
  }

  Widget departure() {
    return Obx(() => flightsList(FlightController.departure.value));
  }

  flightsList(data) {
    /*List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      list.add(Obx(() {
        var flightsPerDay = flights[date];

        if (flightsPerDay == null || flightsPerDay.length == 0) {
          return Center(
            child: Text(df("df_no_data")),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              Color? bg;
              /*List? saved = GetStorage().read('saved_flights');
              List<String> flights_no = [];
              for (var flight in saved ?? []) {
                flights_no.add(flight['flight_no']);
              }
              if (flights_no.contains(flightsPerDay[index]['flight_no'])) {
                bg = Colors.yellow.shade100;
              } else {
                bg = null;
              }*/

              return flightCard2(
                  background: bg,
                  data: flights[index],
                  onLongPress: () {
                    save(flights[index]);
                  });
            },
            itemCount: flights.length,
          );
        }
      }));
    }
    return TabBarView(children: list);*/

    List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      var flights = data[date];
      Widget listItem;
      if (flights == null || flights.length == 0) {
        listItem = Center(
          child: Text(df("df_no_data")),
        );
      } else {
        listItem = ListView.builder(
          itemBuilder: (context, index) {
            Color? background;
            List? saved = GetStorage().read('saved_flights');
            List<String> flightsNo = [];
            for (var flight in saved ?? []) {
              flightsNo.add(flight['flight_no']);
            }
            if (flightsNo.contains(flights[index]['flight_no'])) {
              background = Colors.red.withOpacity(0.1);
            } else {
              background = null;
            }
            return flightCard2(
                background: background,
                data: flights[index],
                onLongPress: () {
                  background == null
                      ? FlightController.save(flights[index])
                      : FlightController.delete(flights[index]['flight_no']);
                });
          },
          itemCount: flights.length,
        );
      }
      list.add(listItem);
    }
    return TabBarView(children: list);
  }
}

//color the saved with lighter color
