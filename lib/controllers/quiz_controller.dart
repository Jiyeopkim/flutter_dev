import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite3/sqlite3.dart';

import '../data/sql_databse.dart';
import '../models/example_model.dart';
import '../models/sql_model.dart';

class QuizController extends GetxController {
  final String tableName = 'lesson';
  var isDataLoading = false.obs;
  var sqlList = <SqlModel>[].obs; 
  var sqlItem = SqlModel().obs;
  ResultSet? result;
  Database? _db;

  Future<void> getDB() async {
    _db ??= await SqlDatabase.db();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    _db?.dispose();
  }

  Future<bool> _getItem() async {
    try
    {
      // 로컬 DB에 있는지 확인
      await getDB();

      var result = _db?.select(
        'SELECT * FROM $tableName ORDER BY RANDOM() LIMIT 1');

      if(result!.isEmpty) {
        showToast('Select Statement', 'No data');
        return false;
      } 
      sqlItem.value = SqlModel.fromMap(result)!;

      return true;
    } catch (e) {
      print(e);
      showToast('GetItem Error: ', e.toString());
      return false;
    }
  }

  Future<bool> _getList(String sql) async {
    // Database db = await SqlDatabase.db();
    await getDB();

    sql = sql.replaceAll("\n", " ");
    sql = sql.replaceAll('\r', ' ');
    sql = sql.replaceAll('"', "'");

    var result = _db?.select('''
SELECT *
FROM $tableName
WHERE title NOT LIKE '$sql'
ORDER BY RANDOM()
LIMIT 3;
    ''');

    if(result!.isEmpty) {
      showToast('Select Statement', 'No data');
      return false;
    }

    // print(result);

    var tempList = <SqlModel>[];

    for (var i = 0; i < result.length; i++) {
      final row = result[i];
      var temp = SqlModel(
        id: row['id'] as int?,
        title: row['title'] as String?,
        simpleEng: row['simple_eng'] as String?,
      );
      tempList.add(temp);
    }

    tempList.add(sqlItem.value);

    sqlList.clear();
    
    sqlList.addAll(shuffleList(tempList));

    if(sqlList.length != 4) {
      return false;
    }
    return true;
  }

  Future<bool> _getItem2() async {
    try
    {
      // 로컬 DB에 있는지 확인
      await getDB();

      String tableName2 = "example";
      var result = _db?.select(
        'SELECT * FROM $tableName2 ORDER BY RANDOM() LIMIT 1');

      if(result!.isEmpty) {
        showToast('Select Statement', 'No data');
        return false;
      } 
      sqlItem.value.title = (ExamModel.fromMap(result)!).content;
      sqlItem.value.simpleEng = (ExamModel.fromMap(result)!).title;

      return true;
    } catch (e) {
      print(e);
      showToast('GetItem Error: ', e.toString());
      return false;
    }
  }

  Future<bool> _getList2(String sql) async {
    // Database db = await SqlDatabase.db();
    await getDB();

    sql = sql.replaceAll("\n", " ");
    sql = sql.replaceAll('\r', ' ');
    sql = sql.replaceAll('"', "'");

    String tableName2 = "example";
    String sql2 = "SELECT * FROM $tableName2 WHERE title NOT LIKE ? ORDER BY RANDOM() LIMIT 3;";
    // sql2 = sql2.replaceAll("\n", " ");

    var result = _db?.select(sql2, [sql]);

    if(result!.isEmpty) {
      showToast('Select Statement', 'No data');
      return false;
    }

    // print(result);

    var tempList = <SqlModel>[];

    for (var i = 0; i < result.length; i++) {
      final row = result[i];
      var temp = SqlModel(
        id: row['id'] as int?,
        // title: row['title'] as String?,
        simpleEng: row['title'] as String?,
      );
      tempList.add(temp);
    }

    tempList.add(sqlItem.value);

    sqlList.clear();
    
    sqlList.addAll(shuffleList(tempList));

    if(sqlList.length != 4) {
      return false;
    }
    return true;
  }

  int _i = 0;
  Future<bool> getQuiz() async {
    _i++;
    if(_i % 3 == 0) {
      await _getItem();
      return await _getList(sqlItem.value.simpleEng ?? ''); 
    }else
    { // 두번째 방식으로 두배 더 많이 출제.
      await _getItem2();
      return await _getList2(sqlItem.value.simpleEng ?? '');
    }
  }

  List<T> shuffleList<T>(List<T> list) {
    Random random = Random();
    for (var i = list.length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
    return list;
  }
  
  void showToast(String title, String msg){
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );            
  }
}
