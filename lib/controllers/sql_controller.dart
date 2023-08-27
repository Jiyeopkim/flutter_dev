// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:learn_sql/data/database.dart';
import 'package:learn_sql/data/sql_databse.dart';

// import '../data/filename.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlparser/sqlparser.dart';

import '../models/example_model.dart';
import '../models/sql_model.dart';

class SqlController extends GetxController {
  final String tableName = 'lesson';
  var isDataLoading = false.obs;
  var sqlList = <SqlModel>[].obs; 
  var sqlItem = SqlModel().obs;
  var examList = <ExamModel>[].obs;
  List<Map<String, Object?>> result = [];

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<bool> getList() async {
    Database db = await SqlDatabase.db();
    
    var result = await db.rawQuery(
          'SELECT * FROM $tableName order by id asc');
    
    print(result);

    sqlList.clear();
    //for loop result and add to chatList
    for (var i = 0; i < result.length; i++) {
      final row = result[i];
      var temp = SqlModel(
        title: row['title'] as String?,
        id: row['id'] as int?,
        simpleKor: row['simple_kor'] as String?,
        simpleEng: row['simple_eng'] as String?,
        creatDt: row['creatDt'] as String?,
      );
      sqlList.add(temp);
    }
    db.close();
    // MyDb db = MyDb();
    // var result = await db.select(db.todos).get();
    // print(result);

  // final database = MyDatabase();

  // // Simple insert:
  // await database
  //     .into(database.categories)
  //     .insert(CategoriesCompanion.insert(description: 'my first category'));
  // // Simple select:
  // final allCategories = await database.select(database.categories).get();
  // print('Categories in database: $allCategories');

    return true;
  }

  Future<bool> getItem(int index) async {
    try
    {
      Database db = await SqlDatabase.db();
      
      var result = await db.rawQuery(
            'SELECT * FROM $tableName where id = $index');
      
      print(result);

      sqlItem.value = SqlModel.fromMap(result)!;

      db.close();
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }
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

  Future<bool> execSql(String sqlState) async {
    Database db = await SqlDatabase.db();
    bool returnResult = false;
    try {
      final engine = SqlEngine();
      final parseResult = engine.parse(sqlState);

      if(parseResult.errors.isNotEmpty) {
        showToast('SQL Syntax Error',parseResult.errors.first.message);
        return false;
      }

      print(parseResult.rootNode.first);

      switch(parseResult.rootNode.runtimeType) {
        case SelectStatement:
          result = await db.rawQuery(sqlState);
          
          if(result.isEmpty) {
            showToast('Select Statement', 'No data');
            returnResult = false;
          } 

          if(result.isNotEmpty) {
            returnResult = true;
          } 

          break;
        case UpdateStatement:
          int count = await db.rawUpdate(sqlState);
          showToast('Update Statement', 'updated: $count');
          break;
        case DeleteStatement:
          int count = await db.rawDelete(sqlState);
          showToast('Delete Statement', 'deleted: $count');
          print('deleted: $count');
          break;
        case InsertStatement:
          int id1 = await db.rawInsert(sqlState);
          print('inserted1: $id1');
          showToast('Insert Statement', 'inserted1: $id1');
          break;
        default:
          await db.execute(sqlState);
          showToast('Defalut', 'defalutly executed');
          break;
      }

    }catch(e) {
      // print(e);
      db.close();
      showToast("SQL Error", e.toString());
      return false;
    }
    db.close();
    return returnResult;
  }

  Future<bool> getExamList(int index) async {
    Database db = await SqlDatabase.db();
    
    var result = await db.rawQuery(
          'SELECT * FROM example where sql_id = $index');
    
    print(result);

    examList.clear();
    //for loop result and add to chatList
    for (var i = 0; i < result.length; i++) {
      final row = result[i];
      var temp = ExamModel(
        title: row['title'] as String?,
        id: row['id'] as int?,
        content: row['content'] as String?,
        contentKor: row['content_kor'] as String?,
      );
      examList.add(temp);
    }
    db.close();

    return true;
  }
}
