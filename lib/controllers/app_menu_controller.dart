import 'package:get/get.dart';
import '../helpers/globals.dart';

class AppMenuController extends GetxController {
  static String endPoint = "menu_api.php";
  static var list = [].obs;
  static var isLoading = false.obs;

  static load() async {
    isLoading.value = true;
    var response = await fetch("$endPoint?action=select");
    isLoading.value = false;
    if (response != null) {
      list.value = response;
    }
  }
}
