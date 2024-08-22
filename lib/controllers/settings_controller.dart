import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helpers/cache.dart';
import '../helpers/constant_keys.dart';
import '../helpers/globals.dart';

class SettingsController extends GetxController {
  static String endPoint = "settings_api.php";
  static String siteUrl = "http://192.168.1.170:2039/";
  static String localSiteUrl = "http://192.168.1.170:2039/";
  static var languages = {}.obs;
  static var preferences = {
    "df_home_en": "Home",
    "df_home_ar": "الرئيسية",
    "df_flight_info_en": "Flight Info",
    "df_flight_info_ar": "حركة الطائرات",
    "df_arrival_en": "Arrival",
    "df_arrival_ar": "الوصول",
    "df_departure_en": "Departure",
    "df_departure_ar": "المغادرة",
    "df_airline_en": "Airline",
    "df_airline_ar": "الخطوط الجوية",
    "df_time_en": "Time",
    "df_time_ar": "الوقت",
    "df_to_en": "To",
    "df_to_ar": "الى",
    "df_from_en": "From",
    "df_from_ar": "من",
    "df_city_en": "City",
    "df_city_ar": "المدينة",
    "df_via_en": "Via",
    "df_via_ar": "عبر",
    "df_counter_en": "Counter",
    "df_counter_ar": "كاونتر",
    "df_status_en": "Status",
    "df_status_ar": "الحالة",
    "df_real_en": "Real Time",
    "df_real_ar": "الوقت الحقيقي"
  }.obs;
  static var lang = "en".obs;
  static var dirc = "ltr".obs;
  static var isLoading = false.obs;
  static Color themeColor = fromHex("#000000");
  static Color themeColor2 = fromHex("#FFFFFF");

  static load() async {
    var response = {};

    if (Cache.has(Cache.settings)) {
      response = Cache.get(Cache.settings);
    } else {
      isLoading.value = true;
      //response = await fetch("$endPoint?action=select");
      response = {
        "languages": {"ar": "ar", "en": "en"},
        "lang": "en"
      };
      isLoading.value = false;
    }

    if (response.isNotEmpty) {
      Cache.set(Cache.settings, response);
      languages.value = response["languages"];
      // preferences.value = response["preferences"];
      /*preferences.value = {
        "df_home_en": "Home",
        "df_home_ar": "الرئيسية",
        "df_arrival_en": "Arrival",
        "df_arrival_ar": "الوصول",
        "df_departure_en": "Departure",
        "df_departure_ar": "المغادرة",
        "df_airline_en": "Airline",
        "df_airline_ar": "الخطوط الجوية",
        "df_time_en": "Time",
        "df_time_ar": "الوقت",
        "df_to_en": "To",
        "df_to_ar": "الى",
        "df_from_en": "From",
        "df_from_ar": "من",
        "df_city_en": "City",
        "df_city_ar": "المدينة",
        "df_via_en": "Via",
        "df_via_ar": "عبر",
        "df_counter_en": "Counter",
        "df_counter_ar": "كاونتر",
        "df_status_en": "Status",
        "df_status_ar": "الحالة",
        "df_real_en": "Real Time",
        "df_real_ar": "الوقت الحقيقي"
      };*/
      setLocale(response["lang"]);
    }
  }

  static setLocale(String lang) {
    String previousLang = GetStorage().read(StorageKey.lang) ?? "";
    if (previousLang.isNotEmpty) {
      lang = previousLang;
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
  }
}
