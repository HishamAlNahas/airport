import 'dart:convert';

import 'package:get/get.dart';

import '../widgets/common.dart';
import 'globals.dart';

class HttpHelper {
  static int? _errorCode;
  static String? _errorText;

  static dynamic fetch(String url, [var body]) async {
    _errorCode = null;
    _errorText = null;

    String separator = url.contains("?") ? "&" : "?";
    url = "$url${separator}lang=${lang()}";

    parr("URL: $url");
    parr("REQUEST BODY: ${body.toString()}");

    String type = (body == null) ? "get" : "post";

    var response = await GetConnect().request(url, type, body: body);

    parr("STATUS TEXT: ${response.statusText.toString()}");
    parr("RESPONSE BODY: ${response.body.toString()}");

    if (!response.status.hasError) {
      var responseBody = jsonDecode(response?.body ?? "{}");
      if (responseBody is List) {
        return responseBody;
      }

      if ((responseBody as Map).containsKey("title") &&
          responseBody["title"] != null) {
        toast(
          title: responseBody["title"],
          message: responseBody["message"],
          status: responseBody["status"],
        );
      }
      return responseBody;
    } else {
      String title = "Error";
      String message = "Server Can't Be Reached";
      if (response.statusCode == null) {
        message = "No Internet Connection";
      }
      toast(
        title: title,
        message: message,
        status: "error",
      );

      _errorCode = response.statusCode;
      _errorText = message;
    }
  }

  static bool hasError() {
    return _errorText != null;
  }

  static int? getErrorCode() {
    return _errorCode;
  }

  static String getErrorText() {
    return _errorText.toString();
  }
}
