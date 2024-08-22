import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

AppBar appBar({
  String text = "",
  bool showDrawer = false,
  List<Widget>? actions,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  return AppBar(
    title: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
    ),
    elevation: 0,
    centerTitle: true,
    backgroundColor: SettingsController.themeColor,
    iconTheme: const IconThemeData(color: Colors.white),
    actions: actions,
    leading: showDrawer
        ? IconButton(
            icon: const FaIcon(FontAwesomeIcons.barsStaggered),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          )
        : Get.routing.route==null
        ?null:Get.routing.route!.isFirst
        ? null
        : IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () {
        Get.back();
      },
    ),

  );
}
