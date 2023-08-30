// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlparser/sqlparser.dart' as sqlparser;
// import 'package:learn_sql/data/database.dart';
import '../data/sql_databse.dart';

// import '../data/filename.dart';
import '../models/example_model.dart';
import '../models/sql_model.dart';

class SqlController extends GetxController {
  final String tableName = 'lesson';
  var isDataLoading = false.obs;
  var sqlList = <SqlModel>[].obs; 
  var sqlItem = SqlModel().obs;
  var examList = <ExamModel>[].obs;
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

  // Future<bool> getDb() async {
  //   db ??= await SqlDatabase.db();
  //   return true;
  // }

  Future<bool> getList() async {
    // Database db = await SqlDatabase.db();
    await getDB();

    var result = _db?.select(
          'SELECT * FROM $tableName order by id asc');
    
    if(result!.isEmpty) {
      showToast('Select Statement', 'No data');
      return false;
    }

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
    // db.dispose();

    return true;
  }

  Future<bool> getItem(int index) async {
    try
    {
      await getDB();
      
      var result = _db?.select(
            'SELECT * FROM $tableName where id = $index');
      
      if(result!.isEmpty) {
        showToast('Select Statement', 'No data');
        return false;
      }      
      print(result);

      sqlItem.value = SqlModel.fromMap(result)!;

      // db.dispose();
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
    await getDB();
    bool returnResult = false;
    try {
      final engine = sqlparser.SqlEngine();
      final parseResult = engine.parse(sqlState);

      if(parseResult.errors.isNotEmpty) {
        showToast('SQL Syntax Error',parseResult.errors.first.message);
        return false;
      }

      print(parseResult.rootNode.first);

      switch(parseResult.rootNode.runtimeType) {
        case sqlparser.SelectStatement:
          result = _db?.select(sqlState);
          
          if(result!.isEmpty) {
            showToast('Select Statement', 'No data');
            returnResult = false;
          } 

          if(result!.isNotEmpty) {
            returnResult = true;
          } 

          break;
        case sqlparser.UpdateStatement:
          _db?.execute(sqlState);
          int count = _db!.getUpdatedRows();
          showToast('Update Statement', 'updated: $count');
          break;
        case sqlparser.DeleteStatement:
          _db?.execute(sqlState);
          int count = _db!.getUpdatedRows();
          showToast('Delete Statement', 'deleted: $count');
          print('deleted: $count');
          break;
        case sqlparser.InsertStatement:
          _db?.execute(sqlState);
          int id1 = _db!.lastInsertRowId;
          print('inserted1: $id1');
          showToast('Insert Statement', 'inserted1: $id1');
          break;
        default:
          _db?.execute(sqlState);
          showToast('Defalut', 'defalutly executed');
          break;
      }

    }catch(e) {
      // print(e);
      showToast("SQL Error", e.toString());
      return false;
    }
    return returnResult;
  }

  Future<bool> getExamList(int index) async {
    Database db = await SqlDatabase.db();
    
    var result = db.select(
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
    db.dispose();

    return true;
  }
}
