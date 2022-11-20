import 'dart:convert';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project/logic/controllers/plan_controller.dart';
import 'package:project/logic/models/task_info.dart';
import 'package:project/logic/services/notification_services.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/setting/setting.dart';
import 'package:project/view/page/task/add_task_page.dart';
import 'package:project/view/page/task/componenet/buttons.dart';
import 'package:project/view/page/task/componenet/task_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  //final int pageId;
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var notifiyHelper = NotifiyHelper();
  int slectedItem = 2;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  String currentUser = "";

  @override
  void initState() {
    super.initState();
    notifiyHelper.InitializNotification();
    notifiyHelper.requestIOSPermissions();
    _getUsers();
  }

  _getUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    if (user != null) {
      var userInfo = jsonDecode(user);
      setState(() {
        currentUser = userInfo['name'];
      });
    } else {
      debugPrint("no info");
    }
  }

  @override
  Widget build(BuildContext context) {
    _taskController.getTask();
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 55, right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "hey".tr,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 32,
                          color: Get.isDarkMode ? Colors.white : Colors.black87,
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
                ],
              ),
            ),
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 10),
            _showTask(),
          ],
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: greenClr.withOpacity(0.7),
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "today".tr,
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: "add_task".tr,
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTask();
            },
          )
        ],
      ),
    );
  }

  _showTask() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Plan task = _taskController.taskList[index];
              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                notifiyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task,
                );
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: _taskController.taskList.length,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task: task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: _taskController.taskList.length,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task: task),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Plan task) {
    Get.bottomSheet(
      Container(
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        padding: const EdgeInsets.only(top: 4),
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "task_complet".tr,
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "delete_task".tr,
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300],
              context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "close".tr,
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300],
              isClosed: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {String? label,
      Function()? onTap,
      Color? clr,
      bool isClosed = false,
      BuildContext? context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context!).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClosed == true
              ? Get.isDarkMode
                  ? Colors.grey[60]
                  : Colors.grey[300]
              : clr!,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label!,
            style: isClosed
                ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
