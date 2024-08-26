import 'package:airport/controllers/flight_controller.dart';
import 'package:airport/screens/home2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import '../helpers/http_helper.dart';
import 'http_error.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    initData();
    splashAnimationInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black12,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/app/wallpaper.jpg"))),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Image.asset(
                  "assets/app/logo.png",
                  width: 150,
                ),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between logo and text
            const CircularProgressIndicator(), // Add progress indicator
            const Expanded(
              child: SizedBox(),
            ),
            Text(
              df("df_slogan"),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      Get.off(() => const STable());
    }
  }

  splashAnimationInit() {
    // Initialize animation controller and fade animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2-second fade-in
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }
}
