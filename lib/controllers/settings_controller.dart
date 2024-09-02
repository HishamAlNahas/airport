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
  static var languages = <String, dynamic>{
    "df_title_en": "Beirut - Rafic Hariri",
    "df_title_ar": "مطار رفيق الحريري",
    "df_subtitle_en": "International Airport",
    "df_subtitle_ar": "الدولي بيروت",
    /*"df_usage_en": "Long Press on a flight to follow it",
    "df_usage_ar": "اضغط مطولا على اي رحلة لمتابعتها",
    "df_arrival_en": "Arrival",
    "df_arrival_ar": "الوصول",
    "df_departure_en": "Departure",
    "df_departure_ar": "المغادرة",
    "df_time_en": "Time",
    "df_time_ar": "الوقت",
    "df_city_en": "City",
    "df_city_ar": "المدينة",
    "df_status_en": "Status",
    "df_status_ar": "الحالة",
    "df_flight_no_en": "Flight No",
    "df_flight_no_ar": "رقم الرحلة",
    "df_search_by_number_or_city_en": "Search by flight number or city name",
    "df_search_by_number_or_city_ar": "ابحث بإسم المدينة او برقم الرحلة",
    "df_no_data_en": "No Data",
    "df_no_data_ar": "لا يجود معلومات",
    "df_saved_flights_en": "Saved Flights",
    "df_saved_flights_ar": "الرحلات المحفوظة",*/
  }.obs;

  static var preferences = {}.obs;
  static var lang = "en".obs;
  static var dirc = "ltr".obs;
  static var isLoading = false.obs;
  static Color themeColor = fromHex("#000000");
  static Color themeColor2 = fromHex("#FFFFFF");

  static load() async {
    var response = {};
    var def = await fetch("$endPoint?action=select_def");
    print(def.runtimeType);
    if (Cache.has(Cache.settings)) {
      response = Cache.get(Cache.settings);
    } else {
      isLoading.value = true;
      //response = await fetch("$endPoint?action=select");
      response = {"lang": "en"};
      var def = await fetch("$endPoint?action=select_def");
      if (def != null) {
        languages.assignAll(def);
        response.addAll({"languages": def});
      }
      isLoading.value = false;
    }

    if (response.isNotEmpty) {
      Cache.set(Cache.settings, response);
      //languages.value = response["languages"];
      // preferences.value = response["preferences"];
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
