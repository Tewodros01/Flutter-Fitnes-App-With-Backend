import 'package:get/get.dart';
import 'package:project/logic/db/db_helper.dart';
import 'package:project/logic/models/task_info.dart';

class TaskController extends GetxController {
  var taskList = <Plan>[].obs;
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({Plan? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTask() async {
    List<Map<String, dynamic>> task = await DBHelper.query();
    taskList.assignAll(task.map((data) => Plan.fromJson(data)).toList());
  }

  void delete(Plan task) {
    DBHelper.delete(task);
    getTask();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
}
