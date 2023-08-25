// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:learn_sql/data/database.dart';
import 'package:learn_sql/data/sql_databse.dart';

// import '../data/filename.dart';
import 'package:sqflite/sqflite.dart';

import '../models/example_model.dart';
import '../models/sql_model.dart';

class SqlController extends GetxController {
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
          'SELECT * FROM sql order by id asc');
    
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
            'SELECT * FROM sql where id = $index');
      
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

  Future<bool> execSql(String sqlState) async {
    Database db = await SqlDatabase.db();
    
    result = await db.rawQuery(sqlState);
    
    print(result);

    db.close();
    return true;
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
