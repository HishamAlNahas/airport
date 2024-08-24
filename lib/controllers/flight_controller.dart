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
    if (departureResponse != null) {
      departure.value.clear();
      var data = {};
      for (var date in dates) {
        data.addAll({
          "${date['STM_DATE']}": departureResponse
              .where((element) => element['day'] == date['STM_DATE'])
              .toList()
        });
      }
      departure.assignAll(data);
    }

    if (arrivalResponse != null) {
      arrival.value.clear();
      var data = {};
      for (var date in dates) {
        data.addAll({
          "${date['STM_DATE']}": arrivalResponse
              .where((element) => element['day'] == date['STM_DATE'])
              .toList()
        });
      }
      arrival.assignAll(data);
    }
  }
}
