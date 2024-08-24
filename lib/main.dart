import 'package:airport/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(GetMaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
        textTheme: _buildTextTheme(ThemeData.dark().textTheme, Colors.black),
        fontFamily: "Dubai",
        primaryColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white54,
          shape: CircleBorder(),
        ),
        tabBarTheme: const TabBarTheme(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            dividerColor: Colors.transparent),
        useMaterial3: true,
        brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    home: const Index(),
  ));
}

TextTheme _buildTextTheme(TextTheme base, Color color) {
  return base.copyWith(
    bodyMedium: base.bodyMedium!.copyWith(fontSize: 16, fontFamily: "Dubai"),
    bodyLarge: base.bodyLarge!.copyWith(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: "Dubai"),
    labelLarge: base.labelLarge!.copyWith(color: color, fontFamily: "Dubai"),
    bodySmall: base.bodySmall!
        .copyWith(color: color, fontSize: 14, fontFamily: "Dubai"),
    headlineSmall: base.headlineSmall!
        .copyWith(color: color, fontSize: 22, fontFamily: "Dubai"),
    titleMedium: base.titleMedium!
        .copyWith(color: color, fontSize: 16, fontFamily: "Dubai"),
    titleLarge: base.titleLarge!.copyWith(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: "Dubai"),
  );
}
