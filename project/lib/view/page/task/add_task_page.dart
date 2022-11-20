import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/logic/controllers/plan_controller.dart';
import 'package:project/logic/models/task_info.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/task/componenet/buttons.dart';
import 'package:project/view/page/task/componenet/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _selectedColorIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, left: 20),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        "add_task_info".tr,
                        style: headingStyle,
                      ),
                      MyInputField(
                        title: "title_one".tr,
                        hint: "enter_title_one".tr,
                        controllerl: _titleController,
                      ),
                      MyInputField(
                        title: "sub_title_one".tr,
                        hint: "enter_title_two".tr,
                        controllerl: _noteController,
                      ),
                      MyInputField(
                        title: "date".tr,
                        hint: DateFormat.yMd().format(_selectedDate),
                        widget: IconButton(
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _getDateFromUser();
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyInputField(
                              title: "start_date".tr,
                              hint: _startTime,
                              widget: IconButton(
                                onPressed: () {
                                  _getTimeFromUser(isStartTime: true);
                                },
                                icon: const Icon(
                                  Icons.access_time_filled_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MyInputField(
                              title: "end_date".tr,
                              hint: _endTime,
                              widget: IconButton(
                                onPressed: () {
                                  _getTimeFromUser(isStartTime: false);
                                },
                                icon: const Icon(
                                  Icons.access_time_filled_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      MyInputField(
                        title: "remind".tr,
                        hint: "$_selectedRemind minuts early",
                        widget: DropdownButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRemind = int.parse(newValue!);
                            });
                          },
                          items: remindList.map<DropdownMenuItem<String>>(
                            (int value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      MyInputField(
                        title: "repeate".tr,
                        hint: "$_selectedRepeat ",
                        widget: DropdownButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRepeat = newValue!;
                            });
                          },
                          items: repeatList.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _colorPallete(),
                          Expanded(
                            child: MyButton(
                              label: "create_task".tr,
                              onTap: () => _validateData(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "color".tr,
          style: titleStyle,
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColorIndex == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("Picker Date is null");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceld");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required ",
        "All fields are required !",
        backgroundColor: Colors.white,
        colorText: Colors.black54,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addTaskToDb() async {
    print(_selectedColorIndex);
    int value = await _taskController.addTask(
        task: Plan(
            color: _selectedColorIndex,
            title: _titleController.text.toString(),
            isCompleted: 0,
            note: _noteController.text.toString(),
            date: DateFormat.yMd().format(_selectedDate).toString(),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat));
    print("Task Id $value");
  }
}
