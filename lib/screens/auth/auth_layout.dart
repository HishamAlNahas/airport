import 'package:flutter/material.dart';

import '../../controllers/settings_controller.dart';
import '../../widgets/common.dart';
import '../../widgets/scaffold.dart';
Widget authLayout({String title="",Widget? body,List<Widget>? actions}){
  return  scaffold(
      backgroundColor: SettingsController.themeColor,
      actions: actions,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child:
                  Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: boxDecoration(
                        color: Colors.white,
                        topLeftRadius: 25,
                      ),
                      child: body
                  ),
                ),
              ],
            ),
          )
        ],
      ));
}