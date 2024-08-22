import 'package:airport/helpers/globals.dart';
import 'package:airport/widgets/scaffold.dart';
import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';

class FlightPage extends StatelessWidget {
  final Map data;
  const FlightPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return scaffold(
      appBarText: data['flight_no'],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            buildFlightDetailCard(
                myPref("df_airline"), Icons.airplanemode_active, "TODO"),
            buildFlightDetailCard(
              myPref("df_time"),
              Icons.access_time,
              data["normal_time"],
            ),
            buildFlightDetailCard(
              data['TYP'] == "A" ? myPref("df_from") : myPref("df_to"),
              Icons.flight_takeoff,
              "${data['country_name']}",
            ),
            buildFlightDetailCard(
              myPref("df_city"),
              Icons.location_city,
              data["city_name"],
            ),
            buildFlightDetailCard(
                myPref("df_via"), Icons.transfer_within_a_station, data["VIA"]),
            buildFlightDetailCard(
                myPref("df_counter"), Icons.countertops, "${data['_path']}"),
            buildFlightDetailCard(
                myPref("df_status"), Icons.info, data["status"]),
            buildFlightDetailCard(
                myPref("df_real"), Icons.schedule, data["estmtd_real_time"]),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget buildFlightDetailCard(String label, IconData icon, String value) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.white12,
            blurRadius: 4,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(colors: [
          SettingsController.themeColor2.withOpacity(0.05),
          SettingsController.themeColor2.withOpacity(0.2)
        ]),
      ),

      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
