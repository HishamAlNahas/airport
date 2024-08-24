import 'package:get/get.dart';

import '../helpers/globals.dart';

class FlightController extends GetxController {
  static String endPoint = "flight_api.php";
  static var departure = {}.obs;
  static var arrival = {}.obs;
  static var dates = [];
  static var isLoading = false.obs;

  static load({String? searchText}) async {
    isLoading.value = true;
    var departureResponse = await fetch("$endPoint?action=select",
        {"type": "D", "lang": lang(), "searchText": searchText});
    var arrivalResponse = await fetch("$endPoint?action=select",
        {"type": "A", "lang": lang(), "searchText": searchText});
    isLoading.value = false;
    dates = await fetch("$endPoint?action=select", {"dates": "true"});
    if (departureResponse != null || true) {
      departure.value.clear();
      departure.assignAll(departureResponse);
    }

    if (arrivalResponse != null || true) {
      arrival.value.clear();
      arrival.assignAll(arrivalResponse);
    }
  }
}
