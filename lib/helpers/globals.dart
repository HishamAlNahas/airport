import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/settings_controller.dart';
import '../helpers/http_helper.dart';
import '../widgets/MyWarningDialog.dart';

String df(String key) {
  return SettingsController.languages["${key}_${lang()}"] ?? key;
}

String pref(String key) {
  return SettingsController.preferences[key] ?? "";
}

dynamic fetch(endPoint, [var body]) {
  String url = fullApiUrl(endPoint);
  return HttpHelper.fetch(url, body);
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String fullSiteUrl([String path = ""]) {
  if (kDebugMode) {
    return SettingsController.localSiteUrl + path;
  }
  return SettingsController.siteUrl + path;
}

String fullUploadUrl(String path) {
  return fullSiteUrl("upload/$path");
}

String fullApiUrl(String path) {
  return fullSiteUrl("cp_api/$path");
}

String lang() {
  return SettingsController.lang.value;
}

String dirc() {
  return SettingsController.lang.value == "ar" ? "rtl" : "ltr";
}

bool isDircLeft() {
  return dirc() == "ltr";
}

bool isDircRight() {
  return dirc() == "rtl";
}

Map<String, dynamic> textEditingControllerData(textEditingController) {
  Map<String, dynamic> data = {};
  textEditingController.forEach((field, textEditer) {
    data[field] = textEditer.text.trim();
  });
  return data;
}

parr(var data) {
  if (kDebugMode) {
    log(data);
  }
}
exitApp(){
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  }
}
Future<bool> onPop(context) async {
  showDialog(
      context: context,
      builder: (context) => MyWarningDialog(
        onWarningPressed: () {
          exitApp();
        },
        translationsWarningButton: df("df_exit"),
        translationsTitle: df("df_exit_message"),
        translationsCancelButton: df("df_cancel"),
      ));

  return false;
}
