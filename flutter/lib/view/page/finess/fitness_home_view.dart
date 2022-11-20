import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/models/workout_info.dart';
import 'package:project/view/components/text_tab.dart';
import 'package:project/view/page/finess/searched_video.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/finess/workout_categoriy.dart';

class FitnessHomeView extends StatefulWidget {
  const FitnessHomeView({super.key});

  @override
  State<FitnessHomeView> createState() => _FitnessHomeViewState();
}

class _FitnessHomeViewState extends State<FitnessHomeView> {
  int slectedItem = 0;
  int selectedTab = 1;
  bool selectedTab1 = true;
  bool selectedTab2 = false;
  bool selectedTab3 = false;
  bool selectedTab4 = false;
  String category = "popular_workout".tr;
  var allvideos = <WorkoutInfo>[];
  var fullBodyWorkout = <WorkoutInfo>[];
  var simpleWorkout = <WorkoutInfo>[];
  var passWorkout = <WorkoutInfo>[];
  var searchWorkout = <WorkoutInfo>[];
  String currentUser = "";

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _getArticles();
    super.initState();
  }

  _getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
  }

  _getArticles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");

    if (user != null) {
      var userInfo = jsonDecode(user);
      currentUser = userInfo['name'];
    } else {
      debugPrint("no info");
    }
    await _initData();
  }

  _initData() async {
    try {
      await CallApi().getPublicData("allworkout").then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          allvideos = list.map((model) => WorkoutInfo.fromJson(model)).toList();
          passWorkout = allvideos;
        });
      });
      _getDataRequested(2);
      _getDataRequested(3);
    } catch (e) {
      print(e);
    }
  }

  _getDataRequested(typeId) async {
    try {
      var data = {
        'type_id': '$typeId',
      };
      await CallApi()
          .getPublicDataByRequest("allworkoutbycategory", data)
          .then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          if (typeId == 2) {
            fullBodyWorkout =
                list.map((model) => WorkoutInfo.fromJson(model)).toList();
          } else {
            simpleWorkout =
                list.map((model) => WorkoutInfo.fromJson(model)).toList();
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? darkGreyClr : Colors.white38,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "hey".tr,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 32,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black26,
                              letterSpacing: 1.8,
                            ),
                          ),
                          Text(
                            currentUser,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 32,
                              color: const Color(0XFF40D876),
                              letterSpacing: 1.8,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xFF40D876),
                          ),
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/logo_2.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white54.withOpacity(.1),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF40D876),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "find".tr,
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              color: const Color(0xFF40D876),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "your_workout".tr,
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.filter_alt_outlined,
                        size: 40,
                        color: Get.isDarkMode ? Colors.white : Colors.black38,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 353,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF232441),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: "search_workout".tr,
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          icon: GestureDetector(
                            onTap: () {
                              _searchVideo();
                            },
                            child: const Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  margin: const EdgeInsets.only(right: 15),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                                passWorkout = allvideos;
                                category = "popular_workout".tr;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab1,
                                name: "popular_workout".tr),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 3;
                                category = "full_body".tr;
                                passWorkout = fullBodyWorkout;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab3,
                                name: "full_body".tr),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 4;
                                category = "simple_workout".tr;
                                passWorkout = simpleWorkout;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab4,
                                name: "simple_workout".tr),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 2;
                                category = "hard_workout".tr;
                                passWorkout = allvideos;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab2,
                                name: "hard_workout".tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                passWorkout.length == 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const CircularProgressIndicator(),
                      )
                    : WorkoutCategoriy(
                        workout_category: category, workout: passWorkout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchVideo() async {
    print(textController.text);
    try {
      var data = {
        'video_title': '${textController.text}',
      };
      await CallApi()
          .getPublicDataByRequest('allsearchworkout', data)
          .then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          searchWorkout =
              list.map((model) => WorkoutInfo.fromJson(model)).toList();
        });
      });
      Get.to(() => SearchedVideo(workout: searchWorkout));
    } catch (e) {
      print(e);
    }
  }

  _slectedTab() {
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
}
