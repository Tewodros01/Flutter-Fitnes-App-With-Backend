import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/book/book_home_view.dart';
import 'package:project/view/page/finess/fitness_home_view.dart';
import 'package:project/view/page/finess/local_fitness_home.dart';
import 'package:project/view/page/task/task_page.dart';
import 'package:project/view/page/user/user_profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int slectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: slectedItem == 0
            ? const LocalFitnessHome()
            : slectedItem == 1
                ? const FitnessHomeView()
                : slectedItem == 2
                    ? const ArticleHomeView()
                    : slectedItem == 3
                        ? const TaskPage()
                        : const UserProfile(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  _bottomNavigationBar() {
    return Container(
      color: context.isDarkMode ? darkGreyClr : Colors.white,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(
          iconSize: 35,
          currentIndex: slectedItem,
          onTap: __onItemTapped,
          backgroundColor: Colors.grey[850],
          selectedIconTheme: const IconThemeData(
            color: Color(0XFF40D876),
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.black26,
          ),
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image(
                  width: 35,
                  height: 35,
                  color: slectedItem == 0
                      ? const Color(0XFF40D876)
                      : Colors.black12,
                  image: const AssetImage(
                    "assets/images/logo_2.png",
                  ),
                ),
              ),
            ),
            const BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.sports_gymnastics,
                ),
              ),
            ),
            const BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.book_online),
              ),
            ),
            const BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.add_task),
              ),
            ),
            const BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.people),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void __onItemTapped(int index) {
    setState(() {
      slectedItem = index;
      if (slectedItem == 0) {
        //Get.to(() => const FitnessHomeView());
      } else if (slectedItem == 1) {
        // Get.to(() => const ArticleHomeView());
      } else if (slectedItem == 2) {
        // Get.to(const TaskPage());
      } else if (slectedItem == 3) {
        // Get.to(const TaskPage());
      }
    });
  }
}
