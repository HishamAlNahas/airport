import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

/*
  static getFlight({required String id}) {
    List data = [];
    print("ppllaa");
    data.addAll(arrival.value.values);
    data.addAll(departure.value.values);
    print("eenndd");
    print(data[0][0].runtimeType);
    print(data[0]);
    var res = data.where(
      (element) => element[0]['flight_no'] == id,
    );
    print(res);
    print("after searching in arrival res");
    if (res != null) {
      return Map().addAll(res);
    } else {
      List saved = GetStorage().read("saved_flights");
      saved.removeWhere(
        (element) => element['flight_no'] == id,
      );
      GetStorage().write("saved_flights", saved);
    }
  }*/
  /*static getFlightOrDelete({required String id}) {
    List data = [];
    fn(data) {
      var res = [];
      for (var e in data) {
        if (e is List) {
          data.addAll(e);
        } else {
          data.add(e);
        }
      }
      return res;
    }

    data.addAll(fn(departure.value.values.toList()));
    data.addAll(fn(arrival.value.values.toList()));
    print(departure.value.values);

    // Search for flights with the given id
    var res = data
        .where(
          (element) => element[0]['flight_no'] == id,
        )
        .toList();
    print("005");
    print(id);
    print("mm55");
    if (res.isNotEmpty) {
      print(res[0][0]['flight_no']);
      print("mm55");
      // Assuming you want to return the first matching result as a Map
      return res[0][0]; // This should be a Map
    } else {
      /*List saved = GetStorage().read("saved_flights");
      saved.removeWhere(
        (element) => element['flight_no'] == id,
      );
      GetStorage().write("saved_flights", saved);*/
    }
  }*/

  static getFlightOrDelete({required String id}) {
    List data = [];
    explodeList(collection) {
      List result = [];
      for (var e in collection) {
        if (e is List) {
          result.addAll(e);
        } else {
          result.add(e);
        }
      }
      return result;
    }

    data.addAll(explodeList(departure.value.values.toList()));
    data.addAll(explodeList(arrival.value.values.toList()));

    print(departure.value.values);
    var res = data
        .where(
          (element) => element['flight_no'] == id,
        )
        .toList();

    if (res.isNotEmpty) {
      return res[0];
    } else {
      List saved = GetStorage().read("saved_flights");
      saved.removeWhere(
        (element) => element['flight_no'] == id,
      );
      GetStorage().write("saved_flights", saved);
    }
  }
}
