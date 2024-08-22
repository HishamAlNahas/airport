import 'package:get/get.dart';

import '../helpers/globals.dart';

class FlightController extends GetxController {
  static String endPoint = "flight_api.php";
  static var departure = {}.obs;
  static var arrival = {}.obs;
  static var dates = [];
  static var isLoading = false.obs;

  static load() async {
    isLoading.value = true;
    //response is [{},{}]; list<Map>;
    var departureResponse =
        await fetch("$endPoint?action=select", {"type": "D", "lang": lang()});
    var arrivalResponse =
        await fetch("$endPoint?action=select", {"type": "A", "lang": lang()});
    print("off");
    isLoading.value = false;
    dates = await fetch("$endPoint?action=select", {"dates": "true"});
/*
    if (departureResponse != null) {
      for (var date in dates) {
        departure.value.addAll({
          "$date": departureResponse
              .where((element) => element['STM_DATE'] == date['STM_DATE'])
              .toList()
        });
      }

      // departure.value = departureResponse;
    }
    if (arrivalResponse != null) {
      for (var date in dates) {
        departure.value.addAll({
          "$date": departureResponse
              .where((element) => element['STM_DATE'] == date['STM_DATE'])
              .toList()
        });
      }
    }*/

    if (departureResponse != null) {
      // departure.value.clear();

      for (var date in dates) {
        var data = {};
        data.addAll({
          "${date['STM_DATE']}": departureResponse
              .where((element) => element['day'] == date['STM_DATE'])
              .toList()
        });
        print(data['2024-08-22'][0]);
        print("case");
        departure.assignAll(data);
        print(departure.value['2024-08-22'][0]);
        print("reall");
      }
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
