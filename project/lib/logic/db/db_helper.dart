import 'package:project/logic/models/task_info.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = '${await getDatabasesPath()}tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("Creating a new one");
          return db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,note TEXT,date TEXT,startTime TEXT,endTime TEXT,remind INTEGER,repeat TEXT,color INTEGER,isCompleted INTEGER)',
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Plan task) async {
    print("Insert function called");
    print(task.title);
    return await _db?.insert(_tableName, task.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query functin called");
    return await _db!.query(_tableName);
  }

  static delete(Plan task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    await _db!
        .rawUpdate('UPDATE tasks SET isCompleted = ? WHERE id = ?', [1, id]);
  }
}
