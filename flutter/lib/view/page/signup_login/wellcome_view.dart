import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/auth/auth_pages.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/home.dart';

class WellComeView extends StatefulWidget {
  const WellComeView({super.key});

  @override
  State<WellComeView> createState() => _WellComeViewState();
}

class _WellComeViewState extends State<WellComeView> {
  final List level = [
    "Inactive".tr,
    "Beginner".tr,
    "Advanced".tr,
  ];
  final List levelInfo = [
    "never_traind".tr,
    "traind".tr,
    "advance".tr,
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "stay".tr,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Text(
                    "helathy".tr,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      color: const Color(0XFF40D876),
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "about_you".tr,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 42,
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "about_you_info".tr,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Get.isDarkMode ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: 226,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: level.length,
                        itemBuilder: (BuildContext ontext, index) {
                          return GestureDetector(
                            onTap: () {
                              _getUserType(index);
                              Get.to(() => const Home());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 226,
                                width: 195,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF232441),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        level[index],
                                        style: GoogleFonts.lato(
                                          fontSize: 30,
                                          color: const Color(0XFF40D876),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        "i_am".tr,
                                        style: GoogleFonts.lato(
                                          fontSize: 30,
                                          color: const Color(0XFF40D876),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        levelInfo[index],
                                        style: GoogleFonts.lato(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 40, top: 40, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "skip_intro".tr,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? Colors.white30
                                : Colors.black38,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const AuthPage());
                          },
                          child: Container(
                            width: 139,
                            height: 39,
                            decoration: BoxDecoration(
                              color: const Color(0XFF40D876),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                "next".tr,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getUserType(index) {
    if (index == 1) {
      print(levelInfo[index]);
    } else {
      print(levelInfo[index]);
    }
  }
}
