import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../helpers/constant_keys.dart';
import '../helpers/globals.dart';
import '../helpers/http_helper.dart';
import '../screens/auth/change_password.dart';
import '../screens/auth/confirm_account.dart';
import '../screens/auth/login.dart';
import '../screens/home.dart';
import '../widgets/common.dart';

class AuthController {
  static String endPoint = "cp/ms/cp_api/member_api.php";
  static var isLoading = false.obs;
  static var member = {};

  static login(var data) async {
    isLoading.value = true;
    data["action"] = "login";
    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data); //http()
    isLoading.value = false;
    if (response != null) {
      if (response["status"] == "success") {
        AuthController.set(response["member"]);
        Get.offAll(() => const Home(), transition: appTransition());
      }
    }
  }

  static register(var data) async {
    isLoading.value = true;
    data["action"] = "register";
    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data); //http()
    isLoading.value = false;
    if (response != null) {
      if (response["status"] == "success") {
        Get.offAll(() => const ConfirmAccount(), transition: appTransition());
      }
    }
  }

  static confirmAccount(var data) async {
    isLoading.value = true;
    data["action"] = "confirm_account";
    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data); //http()
    isLoading.value = false;
    if (response != null) {
      if (response["status"] == "success") {
        Get.offAll(() => Login(), transition: appTransition());
      }
    }
  }

  static forgotPassword(var data) async {
    isLoading.value = true;
    data["action"] = "forgot_password";
    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data); //http()
    isLoading.value = false;
    if (response != null) {
      if (response["status"] == "success") {
        Get.offAll(() => const ChangePassword(), transition: appTransition());
      }
    }
  }

  static changePassword(var data) async {
    isLoading.value = true;
    data["action"] = "change_password";
    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data); //http()
    isLoading.value = false;
    if (response != null) {
      if (response["status"] == "success") {
        Get.offAll(() => Login(), transition: appTransition());
      }
    }
  }

  static updateProfile(var data) async {
    isLoading.value = true;
    data["action"] = "update_profile";
    data["cp__member_id"] = auth("cp__member_id");
    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data); //http()
    isLoading.value = false;
    if (response != null) {
      if (response["status"] == "success") {
        AuthController.set(response["member"]);
      }
    }
  }

  static set(var data) async {
    member = data;
    GetStorage().write(StorageKey.auth, data);
  }

  static find() async {
    var data = {};
    isLoading.value = true;
    data["action"] = "find";
    data["cp__member_id"] = auth("cp__member_id");

    var response = await HttpHelper.fetch(fullSiteUrl(endPoint), data);
    isLoading.value = false;

    if (response != null) {
      if (response["status"] == "success") {
        set(response["member"]);
      } else {
        logout();
      }
    }
  }

  static load() {
    var storedMember = GetStorage().read(StorageKey.auth);
    if (storedMember != null) {
      AuthController.member = storedMember;
      find();
    }
  }

  static logout() async {
    await GetStorage().remove(StorageKey.auth);
    AuthController.member = {};
    Get.offAll(() => Login(), transition: appTransition());
  }
}
