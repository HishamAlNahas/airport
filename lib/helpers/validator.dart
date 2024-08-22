import "package:get/get_utils/src/get_utils/get_utils.dart";

class Validator{

  static bool isEmail(String? value) {
    value = value?.trim();
    return GetUtils.isEmail(value ?? "");
  }

  static bool isPassword(String? value) {
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');
    return regex.hasMatch(value ?? "");
  }

  static bool isPhone(String value) {
    String pattern = r'^\d{8,}$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isNumber(String value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }


  static  bool isEmpty(String? value) {
    if (value == null) {
      return false;
    }
    return value.isEmpty;
  }

  static bool isNumeric(String? value) {
    return GetUtils.isNum(value ?? "");
  }

}