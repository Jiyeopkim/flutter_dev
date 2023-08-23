import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class SqlDatabase {
  static Future<sql.Database> db() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "sql.db3");

    // 디비 파일이 있는지 확인한다.
    var exists = await databaseExists(path);

    if (!exists) {
      // 없으면 폴더를 만들고 디비 파일을 복사한다.
      debugPrint("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "sql.db3"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint("<<syeeze>>Opening existing database");
      ByteData data = await rootBundle.load(join("assets", "sql.db3"));

      int length1 = await File(path).length();
      int length2 = data.lengthInBytes;
      //파일 크기가 다르면 디비에 내용이 추가된것이므로 파일을 복사한다.
      // if (length1 != length2) {
      if (true) {
        debugPrint("Creating new copy from asset");
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      }
    }

    return await openDatabase(path, readOnly: false);
    // return await openDatabase(path, null, SQLiteDatabase.OPEN_READONLY);
  }
}
