import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helpers/cache.dart';
import '../helpers/constant_keys.dart';
import '../helpers/globals.dart';
import 'flight_controller.dart';

class SettingsController extends GetxController {
  static String endPoint = FlightController.endPoint;
  static String siteUrl = "https://beirutairport.gov.lb/";
  static String localSiteUrl = "https://beirutairport.gov.lb/";
  // static String siteUrl = "http://192.168.1.170:2039/";
  //static String localSiteUrl = "http://192.168.1.170:2039/";
  static var languages = <String, dynamic>{
    "df_title_en": "Beirut - Rafic Hariri",
    "df_title_ar": "مطار رفيق الحريري",
    "df_subtitle_en": "International Airport",
    "df_subtitle_ar": "الدولي بيروت",
  }.obs;

  static var preferences = {}.obs;
  static var lang = "${GetStorage().read(StorageKey.lang) ?? 'ar'}".obs;
  static var isLoading = false.obs;
  static Color themeColor = fromHex("#000000");
  static Color themeColor2 = fromHex("#FFFFFF");

  static load() async {
    var response = {};
    if (Cache.has(Cache.settings)) {
      response = Cache.get(Cache.settings);
    } else {
      isLoading.value = true;
      response = await fetch("$endPoint?action=select_def");
      if (response["languages"] != null) {
        languages.assignAll(response["languages"]);
      }
      isLoading.value = false;
    }
    print(response);
    print(response.runtimeType);
    if (response.isNotEmpty) {
      Cache.set(Cache.settings, response);
      // preferences.value = response["preferences"];
      setLocale(GetStorage().read(StorageKey.lang) ?? response["lang"]);
    }
  }

  static setLocale(String lang) {
    print("Setting locale");
    print(lang);
    String previousLang = GetStorage().read(StorageKey.lang) ?? "";
    if (previousLang.isNotEmpty) {
      lang = previousLang;
      print(lang);
    }
    updateLocal(lang);
  }

  static changeLanguage() async {
    String otherLang = (SettingsController.lang.value == "en") ? "ar" : "en";
    updateLocal(otherLang);
  }

  static updateLocal(String lang) {
    var locale = Locale(lang);
    Get.updateLocale(locale);
    SettingsController.lang.value = lang;
    GetStorage().write(StorageKey.lang, lang);
    print("innn");
    print(GetStorage().read(StorageKey.lang));
  }
}
