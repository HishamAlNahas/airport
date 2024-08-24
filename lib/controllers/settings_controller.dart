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
  static var languages = {
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
    "df_real_ar": "الوقت الحقيقي",
    "df_search_by_number_or_city_en": "Search by flight number or city name",
    "df_search_by_number_or_city_ar": "ابحث بإسم المدينة او برقم الرحلة",
    "df_no_data_en": "No Data",
    "df_no_data_ar": "لا يجود معلومات"
  }.obs;
  //لإ×]× remove them from the preferneces  TODO
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
    "df_country_en": "Country",
    "df_country_ar": "الدولة",
    "df_via_en": "Via",
    "df_via_ar": "عبر",
    "df_counter_en": "Counter",
    "df_counter_ar": "كاونتر",
    "df_status_en": "Status",
    "df_status_ar": "الحالة",
    "df_real_en": "Real Time",
    "df_real_ar": "الوقت الحقيقي",
    "df_search_by_number_or_city_en": "Search by flight number or city name",
    "df_search_by_number_or_city_ar": "ابحث بإسم المدينة او برقم الرحلة",
    "df_no_data_en": "No Data",
    "df_no_data_ar": "لا يجود معلومات",
    "df_saved_flights_en": "Saved Flights",
    "df_saved_flights_ar": "الرحلات المحفوظة",
    "df_saved_en": "Saved",
    "df_saved_ar": "تم حفظها",
    "df_saved_message_en": "added to the saved flights",
    "df_saved_message_ar": "تم اضافتها لصفحة الرحلات المحفوظة",
    "df_deleted_en": "deleted",
    "df_deleted_ar": "تمت ازالتها",
    "df_deleted_message_en": "removed from the saved flights",
    "df_deleted_message_ar": "ازيلت من الرحلات المحفوظة"
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
