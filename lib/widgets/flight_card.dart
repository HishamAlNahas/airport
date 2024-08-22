import 'package:airport/controllers/settings_controller.dart';
import 'package:airport/helpers/globals.dart';
import 'package:airport/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/flight_page.dart';
import 'common.dart';

class FlightCard extends StatelessWidget {
  final Map data;

  const FlightCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Get.to(() => FlightPage(
              data: data,
            ));
      },
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10, right: 10, top: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.white12,
              blurRadius: 4,
              offset: Offset(4, 8), // Shadow position
            ),
          ],
          gradient: LinearGradient(colors: [
            SettingsController.themeColor2.withOpacity(0.05),
            SettingsController.themeColor2.withOpacity(0.2)
          ]),
          borderRadius: BorderRadius.circular(
              50), /*color: SettingsController.themeColor2.withOpacity(0.1)*/
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ImageToTransparent("assets/images/plane2.png",
                      height: 40),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color(0xffB8860B),
                            Color(0xffd4af37),
                            Color(0xffffd700),
                          ]),
                          borderRadius: BorderRadius.circular(45)),
                      child: Text(
                        "${data["flight_no"]}",
                        style: colorStyle(color: Colors.black54, isBold: true),
                      )),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border_rounded)),
                  ),*/
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data["city_name"] ?? myPref("df_err"),
                    style: colorStyle(isBold: true),
                  ),
                  Text(
                    data["status"] ?? myPref("df_err"),
                    style: colorStyle(isBold: true),
                  ),
                  Text(data["estmtd_real_time"] ?? myPref("df_err"),
                      style: colorStyle(isBold: true)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
