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
              title: Text(
                df("df_flight_info"),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                flightCard2(data: {
                  "normal_time": df("df_time"),
                  "flight_no": df("df_flight_no"),
                  "city_name": df("df_city"),
                  "status": df("df_status")
                }),
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
    List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      list.add(Obx(() {
        var arrival = FlightController.arrival.value;
        var flights = arrival[date];

        if (flights == null || flights.length == 0) {
          return Center(
            child: Text(df("df_no_data")),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return flightCard2(
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
    return TabBarView(children: list);
  }

  Widget departure() {
    List<Widget> list = [];
    for (int i = 0; i < FlightController.dates.length; i++) {
      var date = FlightController.dates[i]['STM_DATE'];
      list.add(Obx(() {
        var departure = FlightController.departure.value;
        var flights = departure[date];

        if (flights == null || flights.length == 0) {
          return Center(
            child: Text(df("df_no_data")),
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return flightCard2(
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
    return TabBarView(children: list);
  }

  void save(row) {
    toast(
        title: df("df_saved"),
        message: df("df_saved_message"),
        customColor: Colors.black);
    List? res = GetStorage().read('saved_flights');
    if (res == null || res.isEmpty) {
      res = [row];
    } else {
      // var found = res.where(
      //   (element) => element['flight_no'] == row['flight_no'],
      // );
      // if (found.isEmpty) {
      res.add(row);
      // }
      print("rrrrrrrrrrrrrrrr ${res}");
    }
    print("res.length== ${res.length}");
    GetStorage().write('saved_flights', res);
  }
}

//color the saved with lighter color
