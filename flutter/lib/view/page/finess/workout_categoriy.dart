import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/models/workout_info.dart';
import 'package:project/view/page/finess/detail_video.dart';

class WorkoutCategoriy extends StatelessWidget {
  final List<WorkoutInfo>? workout;
  String? workout_category;
  WorkoutCategoriy(
      {super.key, required this.workout, required this.workout_category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              Text(
                workout_category!,
                style: GoogleFonts.lato(
                  fontSize: 30,
                  color: Get.isDarkMode ? Colors.white : Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              itemCount: workout?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => DetailVideo(
                                videoInfo: workout![index],
                              ));
                        },
                        child: workout!.length == 0
                            ? CircularProgressIndicator()
                            : Container(
                                height: 160,
                                width: 141,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      "http://10.0.2.2:8000/uploads/${workout![index].workout_thumbnail!}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      workout!.length == 0
                          ? CircularProgressIndicator()
                          : Text(
                              workout![index].workout_title!,
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
