import 'package:flutter/material.dart';
import '../controllers/app_menu_controller.dart';
import '../controllers/settings_controller.dart';
import '../helpers/globals.dart';
import 'common.dart';

Drawer drawer() {
  TextStyle menuTextStyle = const TextStyle(
    fontSize: 24,
  );
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: SettingsController.themeColor2,
            ), //BoxDecoration
            child: logo()//UserAccountDrawerHeader
            ), //DrawerHeader
        Padding(

          padding: const EdgeInsets.all(8),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.spaceAround ,
            children: [
              for (var menu in AppMenuController.list)
                Column(
                  children: [
                    menu['sub'].length > 0
                        ?
                    PopupMenuButton<int>(
                            offset: Offset(20 * (isDircLeft() ? 1 : -1), 45.0),
                            shadowColor: Colors.white,
                            onSelected: (item) => {},
                            itemBuilder: (context) => [
                              for (var subMenu in menu['sub'])
                                PopupMenuItem<int>(
                                    value: int.parse(subMenu['ot__menu_id']),
                                    child: InkWell(
                                      onTap: () {
                                        // Get.to(() => Webscreen(
                                        //     url: fullSiteUrl(
                                        //         subMenu['menu_page_link']),
                                        //     title: subMenu['menu_page_title']));
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.arrow_forward),
                                          Text(
                                            subMenu['ot__menu_name_${lang()}'],
                                            style: menuTextStyle,
                                          ),
                                        ],
                                      ),
                                    )),
                            ],
                            child: Row(
                              children: [
                                Text(
                                  menu['menu_page_title'],
                                  style: menuTextStyle,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              // Get.to(() => Webscreen(
                              //     url: fullSiteUrl(
                              //         menu['menu_page_link']),
                              //     title: menu['menu_page_title']));
                            },
                            child: Text(
                              menu['ot__menu_name_${lang()}'],
                              style: menuTextStyle,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),


            ],

          ),
        )
      ],
    ),
  );
}
