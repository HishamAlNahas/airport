import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import '../helpers/validator.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import 'scaffold.dart';

BoxDecoration boxDecoration({
  Color color = Colors.transparent,
  double bottomLeftRadius = 0,
  double bottomRightRadius = 0,
  double topLeftRadius = 0,
  double topRightRadius = 0,
  double borderRadius = 0,
  Color borderColor = Colors.transparent,
  double borderWidth = 0,
  Color shadowColor = Colors.transparent,
}) {
  if (borderRadius > 0) {
    bottomLeftRadius = borderRadius;
    bottomRightRadius = borderRadius;
    topLeftRadius = borderRadius;
    topRightRadius = borderRadius;
  }

  return BoxDecoration(
    color: color,
    border: Border.all(color: borderColor, width: borderWidth),
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius),
        topLeft: Radius.circular(topLeftRadius),
        topRight: Radius.circular(
          topRightRadius,
        )),
    boxShadow: [
      BoxShadow(
        color: shadowColor,
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}

InputDecoration inputDecoration({
  String label = "",
  String hint = "",
  Icon? prefixIcon,
  double borderRadius = 12,
}) {
  return InputDecoration(
    label: Text(
      label,
      style: const TextStyle(fontSize: 16),
    ),
    hintText: hint,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: SettingsController.themeColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: SettingsController.themeColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: SettingsController.themeColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
    errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
  );
}

TextFormField inputEmail({
  TextEditingController? emailController,
}) {
  return TextFormField(
    decoration: inputDecoration(
      label: df("df_email"),
      prefixIcon: const Icon(Icons.mail),
    ),
    controller: emailController,
    validator: (value) {
      return !Validator.isEmail(value) ? df("df_required_email") : null;
    },
    textInputAction: TextInputAction.next,
  );
}

TextFormField inputPassword({
  TextEditingController? passwordController,
}) {
  return TextFormField(
    decoration: inputDecoration(
      label: df("df_password"),
      prefixIcon: const Icon(Icons.lock),
    ),
    obscureText: true,
    controller: passwordController,
    validator: (value) {
      return !Validator.isPassword(value) ? df("df_required_password") : null;
    },
    textInputAction: TextInputAction.next,
  );
}

MaterialButton button(
    {String text = "",
    Icon? icon,
    Color? color,
    VoidCallback? onPressed,
    double borderRadius = 12,
    Color? borderColor,
    Color? textColor}) {
  color ??= SettingsController.themeColor;
  return MaterialButton(
    elevation: 0,
    onPressed: onPressed,
    color: color,
    padding: const EdgeInsets.all(15),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon != null
            ? Row(
                children: [
                  icon,
                  const SizedBox(
                    width: 5,
                  )
                ],
              )
            : const SizedBox(),
        Text(
          text,
          style: TextStyle(color: textColor ?? Colors.white),
        )
      ],
    ),
  );
}

Widget br([double height = 20]) {
  return SizedBox(height: height);
}

Transition appTransition() {
  return Transition.rightToLeft;
}

Widget label(String text) {
  return Row(
    children: [
      Text(
        text,
        style: TextStyle(
            color: SettingsController.themeColor, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget appLoader() {
  return const CircularProgressIndicator();
}

Image logo() {
  return Image.asset("assets/app/logo.jpg");
}

colorStyle(
    {bool isBold = false, Color color = Colors.white70, isSmall = false}) {
  return TextStyle(
      color: color,
      fontWeight: isBold ? FontWeight.bold : null,
      fontSize: isSmall ? 12 : null);
}

SnackbarController toast(
    {String title = "title",
    String message = "message",
    String status = "status"}) {
  Color? color =
      (status == "success") ? Colors.green[200] : Colors.redAccent[200];
  return Get.snackbar(
    title,
    message,
    backgroundColor: color,
    colorText: Colors.white,
  );
}

Widget authRequired(Widget layout) {
  return (!isAuth()) ? loginRequired() : layout;
}

Widget loginRequired() {
  return scaffold(
      appBarText: df("df_auth_required"),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          br(50),
          Image.asset('assets/images/login.png'),
          br(20),
          Text(df("df_user_auth_required")),
          br(20),
          button(
              text: "Login",
              color: Colors.blueGrey,
              onPressed: () {
                Get.to(() => Login(), transition: appTransition());
              }),
          br(20),
          button(
              text: "Register",
              color: Colors.white,
              textColor: Colors.blueGrey,
              borderColor: Colors.blueGrey,
              onPressed: () {
                Get.to(() => const Register(), transition: appTransition());
              }),
        ]),
      ));
}
