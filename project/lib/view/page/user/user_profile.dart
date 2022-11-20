import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/models/get_book_info.dart';
import 'package:project/logic/models/user.dart';
import 'package:project/logic/models/workout_info.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_tab.dart';
import 'package:project/view/page/book/book_category.dart';
import 'package:project/view/page/finess/workout_categoriy.dart';
import 'package:project/view/page/setting/setting.dart';
import 'package:project/view/page/user/utils/user_preferences.dart';
import 'package:project/view/page/user/widget/profile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final user = UserPreferences.myUser;
  int slectedItem = 1;
  int selectedTab = 1;
  bool selectedTab1 = true;
  bool selectedTab2 = false;
  bool selectedTab3 = false;
  bool selectedTab4 = false;
  var books = <BookInfo>[];
  var allBooks = <BookInfo>[];
  var passBook = <BookInfo>[];
  var allvideos = <WorkoutInfo>[];
  var passWorkout = <WorkoutInfo>[];
  String currentUser = "";
  String email = "";
  int? user_id;
  String category = "liked_books".tr;
  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  _getUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    if (user != null) {
      setState(() {
        var userInfo = jsonDecode(user);
        currentUser = userInfo['name'];
        email = userInfo['email'];
        user_id = userInfo['id'];
      });
    } else {
      debugPrint("no info");
    }
    await _initData();
  }

  _initData() async {
    try {
      var data = {
        'user_id': '$user_id',
      };
      print(user_id);
      var res = await CallApi()
          .getPublicDataByRequest('alllikedbook', data)
          .then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          allBooks = list.map((model) => BookInfo.fromJson(model)).toList();
          passBook = allBooks;
        });
      });

      await CallApi()
          .getPublicDataByRequest("alllikedworkout", data)
          .then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          allvideos = list.map((model) => WorkoutInfo.fromJson(model)).toList();
          passWorkout = allvideos;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.isDarkMode ? darkGreyClr : Colors.white,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      Get.to(() => const Settings());
                    });
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                      border: Border.all(
                        width: 3,
                        color: const Color(0xFF40D876),
                      ),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: user.imagePath!,
                  ),
                  const SizedBox(height: 24),
                  buildName(),
                  const SizedBox(height: 24),
                  Container(
                    height: 70,
                    margin: const EdgeInsets.only(left: 70, right: 20),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Center(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 1;
                                    passBook = allBooks;
                                    category = "liked_books".tr;
                                    _slectedTab();
                                  });
                                },
                                child: TextTab(
                                  selectedTab: selectedTab1,
                                  name: "liked_books".tr,
                                ),
                              ),
                              const SizedBox(width: 40),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 2;
                                    passWorkout = allvideos;
                                    category = "liked_video".tr;
                                    _slectedTab();
                                  });
                                },
                                child: TextTab(
                                  selectedTab: selectedTab2,
                                  name: "liked_video".tr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
            passData(),
          ],
        ),
      ),
    );
  }

  Widget passData() {
    if (selectedTab == 1) {
      if (passBook.isEmpty) {
        return Container(
          margin: const EdgeInsets.only(top: 70),
          child: const CircularProgressIndicator(),
        );
      } else {
        return BookCategory(category: category, book: passBook);
      }
    } else {
      if (passWorkout.isEmpty) {
        return Container(
          margin: const EdgeInsets.only(top: 50),
          child: const CircularProgressIndicator(),
        );
      } else {
        return WorkoutCategoriy(
            workout_category: category, workout: passWorkout);
      }
    }
  }

  _slectedTab() {
    bool isSekected = false;
    if (selectedTab == 1) {
      selectedTab1 = true;
      selectedTab2 = false;
      selectedTab3 = false;
      selectedTab4 = false;
    } else if (selectedTab == 2) {
      selectedTab1 = false;
      selectedTab2 = true;
      selectedTab3 = false;
      selectedTab4 = false;
    } else if (selectedTab == 3) {
      selectedTab1 = false;
      selectedTab2 = false;
      selectedTab3 = true;
      selectedTab4 = false;
    } else if (selectedTab == 4) {
      selectedTab1 = false;
      selectedTab2 = false;
      selectedTab3 = false;
      selectedTab4 = true;
    }
  }

  Widget buildName() {
    return Column(
      children: [
        Text(
          currentUser,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
