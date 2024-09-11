import 'dart:async';

import 'package:airport/controllers/flight_controller.dart';
import 'package:airport/screens/saved_flights.dart';
import 'package:airport/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import '../widgets/MyWarningDialog.dart';
import '../widgets/common.dart';
import '../widgets/flight_card2.dart';

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

  Future<bool> onPop() async {
    showDialog(
        context: context,
        builder: (context) => MyWarningDialog(
              onWarningPressed: () {
                FlutterExitApp.exitApp();
              },
              translationsWarningButton: df("df_exit"),
              translationsTitle: df("df_exit_message"),
              translationsCancelButton: df("df_cancel"),
            ));

    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Text> tabs = [];
    for (var date in FlightController.dates) {
      tabs.add(Text(date['STM_DATE']));
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        if (didPop) {
          return;
        }
        onPop();
      },
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.5,
                image: AssetImage("assets/app/wallpaper.jpg"))),
        child: DefaultTabController(
          length: FlightController.dates.length,
          child: Directionality(
            textDirection:
                dirc() == "rtl" ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  //backgroundColor: SettingsController.themeColor.withOpacity(0.7),
                  backgroundColor: Colors.white,
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
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              df("df_subtitle"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: refresh,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () async {
                          await SettingsController.changeLanguage();
                          await refresh();
                        },
                        icon: const Icon(
                          Icons.language,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SearchDialog(),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  ],
                  bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 65),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  selectedIndex = 0;
                                  setState(() {});
                                },
                                style: ButtonStyle(
                                    side: WidgetStatePropertyAll(
                                        selectedIndex == 0
                                            ? const BorderSide(
                                                color: Colors.black)
                                            : null),
                                    foregroundColor: selectedIndex == 0
                                        ? null
                                        : const WidgetStatePropertyAll(
                                            Colors.grey)),
                                child: Row(
                                  children: [
                                    Text(df('df_arrival')),
                                    const Icon(
                                      Icons.flight_land_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                style: ButtonStyle(
                                    side: WidgetStatePropertyAll(
                                        selectedIndex == 1
                                            ? const BorderSide(
                                                color: Colors.black)
                                            : null),
                                    foregroundColor: selectedIndex == 1
                                        ? null
                                        : const WidgetStatePropertyAll(
                                            Colors.grey)),
                                onPressed: () {
                                  selectedIndex = 1;
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Text(df('df_departure')),
                                    const Icon(
                                      Icons.flight_takeoff_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TabBar(
                            tabs: tabs,
                          ),
                        ],
                      ))),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                    child: tableHeader(),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bodies[selectedIndex],
                  )),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          await launchUrl(Uri.parse('https://opentech.me/'));
                        },
                        child: Text(
                          "${df("df_developed_by")} OpenTech",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.white,
                mini: true,
                onPressed: () {
                  Get.offAll(() => SavedFlights());
                },
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    await FlightController.load();
    Navigator.pop(context);
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
        listItem = RefreshIndicator(
          onRefresh: () => FlightController.load(),
          child: ListView.builder(
            itemBuilder: (context, index) {
              bool isSaved = false;
              List? saved = GetStorage().read('saved_flights');
              List<String> flightsNo = [];
              for (var flight in saved ?? []) {
                flightsNo.add(flight['flight_no']);
              }
              if (flightsNo.contains(flights[index]['flight_no'])) {
                isSaved = true;
              } else {
                isSaved = false;
              }
              return FlightCard2(
                  isSaved: isSaved,
                  data: flights[index],
                  onLongPress: () {
                    isSaved == false
                        ? FlightController.save(flights[index])
                        : FlightController.delete(flights[index]['flight_no']);
                  });
            },
            itemCount: flights.length,
          ),
        );
      }
      list.add(listItem);
    }
    return TabBarView(children: list);
  }
}
