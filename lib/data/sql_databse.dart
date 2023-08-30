import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class SqlDatabase {
  static bool isLoaded = false;

  static Future<Database> db() async {
    if(Platform.isWindows){
      isLoaded = true;
      Directory current = Directory.current;
      return sqlite3.open('${current.path}/assets/sql.db3');
      // return await openDatabase(path, null, SQLiteDatabase.OPEN_READONLY);
    }else
    {
      isLoaded = true;
      var databasesPath = await getApplicationDocumentsDirectory();
      var path = join(databasesPath.path, "sql.db3");
      var exists = await File(path).exists();

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

      return sqlite3.open(path);
      }
    }
}