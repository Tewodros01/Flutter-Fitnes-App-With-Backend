import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/auth/auth_pages.dart';
import 'package:project/logic/services/notification_services.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/logic/services/theme_services.dart';
import 'package:project/logic/services/languge_services.dart';
import 'package:project/view/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var notifiyHelper = NotifiyHelper();

  List<String> settingList = [
    "change_languge".tr,
    "change_thems".tr,
    "log_out".tr,
  ];
  List locales = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'አማርኛ', 'locale': const Locale('et', 'ET')},
    {'name': 'ትግሪኛ', 'locale': const Locale('et', 'TG')},
    {'name': 'Afaan Oromoo', 'locale': const Locale('et', 'OR')},
  ];
  List them = [
    {'name': 'Dark'},
    {'name': 'Ligth'},
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.isDarkMode ? darkGreyClr : Colors.white,
      child: Container(
        margin: const EdgeInsets.only(top: 70, left: 10),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Home());
                  },
                  child: Icon(
                    Icons.home,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: settingList.length,
                separatorBuilder: (context, index) {
                  return Container();
                },
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (index == 0) {
                            _buildingDialog(context);
                          } else if (index == 1) {
                            _buildingDialogThem(context);
                          } else if (index == 2) {
                            _logout();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[850],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, bottom: 10),
                            child: Text(
                              settingList[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updateLanguge(Locale local) {
    Get.back();
    Get.updateLocale(local);
    settingList = [
      "change_languge".tr,
      "change_thems".tr,
      "log_out".tr,
    ];
  }

  _updateThem(int index) {
    if (index == 0) {
      if (Get.isDarkMode == false) {
        ThemeServices().switchTheme();
      }
    } else {
      if (Get.isDarkMode == true) {
        ThemeServices().switchTheme();
      }
    }

    Get.back();
  }

  _logout() async {
    await CallApi().getData("logout").then((response) {
      setState(() {
        print("Response : ${response.body}");
      });
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
    Get.to(() => const AuthPage());
  }

  _buildingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (bulder) {
        return AlertDialog(
          title: Text("choose_languge".tr),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print("index ${index}");
                    _updateLanguge(locales[index]['locale']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(locales[index]['name']),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.blue,
                );
              },
              itemCount: locales.length,
            ),
          ),
        );
      },
    );
  }

  _buildingDialogThem(BuildContext context) {
    showDialog(
      context: context,
      builder: (bulder) {
        return AlertDialog(
          title: Text("choose_them".tr),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print("index ${index}");
                    _updateThem(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(them[index]['name']),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.blue,
                );
              },
              itemCount: them.length,
            ),
          ),
        );
      },
    );
  }
}
