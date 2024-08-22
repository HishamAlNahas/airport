import 'package:airport/controllers/flight_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/settings_controller.dart';
import '../helpers/http_helper.dart';
import '../widgets/common.dart';
import 'home2.dart';
import 'http_error.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: appLoader(),
      ),
    );
  }

  initData() async {
    await GetStorage.init();
    await SettingsController.load();
    await FlightController.load();
    // await AppMenuController.load();
    // AuthController.load();

    if (HttpHelper.hasError()) {
      Get.offAll(() => const HttpError(), transition: Transition.rightToLeft);
    } else {
      Get.off(() => STable());
    }
  }
}
