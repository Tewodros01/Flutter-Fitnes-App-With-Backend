import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/models/workout_info.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_widget.dart';
import 'package:project/view/page/finess/detail_video.dart';
import 'package:project/view/page/home.dart';

class SearchedVideo extends StatefulWidget {
  final List<WorkoutInfo>? workout;
  const SearchedVideo({super.key, this.workout});

  @override
  State<SearchedVideo> createState() => _SearchedVideoState();
}

class _SearchedVideoState extends State<SearchedVideo> {
  List<WorkoutInfo>? workouts;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    workouts = widget.workout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Material(
      color: context.isDarkMode ? darkGreyClr : Colors.white,
      child: Container(
        margin: const EdgeInsets.only(top: 40, left: 5),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.home_outlined,
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
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
              workouts!.isEmpty
                  ? Center(
                      child: Text(
                        "No Result",
                        style: TextStyle(
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: workouts!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 170,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => DetailVideo(
                                        videoInfo: workouts![index],
                                      ));
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 35,
                                      child: Material(
                                        elevation: 0.0,
                                        child: Container(
                                          height: 130.0,
                                          width: width * 0.9,
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? Colors.black12
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Get.isDarkMode
                                                    ? Colors.black
                                                        .withOpacity(0.5)
                                                    : Colors.grey
                                                        .withOpacity(0.3),
                                                offset: const Offset(0.0, 0.0),
                                                blurRadius: 20.0,
                                                spreadRadius: 4.0,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      child: Card(
                                        elevation: 10.0,
                                        shadowColor: Get.isDarkMode
                                            ? darkGreyClr.withOpacity(0.3)
                                            : Colors.white10.withOpacity(0.6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Container(
                                          height: 130,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: CachedNetworkImageProvider(
                                                "http://10.0.2.2:8000/uploads/${workouts![index].workout_thumbnail!}",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 45,
                                      left: width * 0.4,
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: workouts![index]
                                                  .workout_title,
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                            TextWidget(
                                              text:
                                                  "Author ${workouts![index].workout_author}",
                                              fontSize: 14,
                                            ),
                                            const Divider(color: Colors.black),
                                            TextWidget(
                                              text: workouts![index]
                                                  .workout_description,
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _searchVideo() async {
    print(textController.text);
    var data = {
      'workout_title': '${textController.text}',
    };
    await CallApi()
        .getPublicDataByRequest('allsearchworkout', data)
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        workouts = list.map((model) => WorkoutInfo.fromJson(model)).toList();
      });
    });
  }
}
