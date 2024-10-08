import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

Scaffold scaffold(
    {String appBarText = "",
    Widget? body,
    bool showDrawer = false,
    Color backgroundColor = Colors.white,
    List<Widget>? actions}) {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  return Scaffold(
    key: scaffoldKey,
    backgroundColor: backgroundColor,
    appBar: appBar(
        scaffoldKey: scaffoldKey,
        text: appBarText,
        showDrawer: showDrawer,
        actions: actions),
    body: body,
  );
}
