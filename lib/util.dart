import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

void changeStatusBarColor() {
  // exit if running on the web
  // if (kIsWeb) {
  //   return;
  // }

  if (Platform.isAndroid) {
    //is drak mode
    if (Get.isDarkMode)
    {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: TheApp.backColor, //상단 스테이터스바 색상
      // statusBarIconBrightness: Brightness.dark, //상단 아이콘 색상.
      // systemNavigationBarColor: Colors.black, //하단 네비게이션바 색상
      systemNavigationBarIconBrightness: Brightness.light));
    }else
    {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(

      // statusBarColor: TheApp.backColor, //상단 스테이터스바 색상
      // statusBarIconBrightness: Brightness.dark, //상단 아이콘 색상.
      // systemNavigationBarColor: Colors.white, //하단 네비게이션바 색상
      systemNavigationBarIconBrightness: Brightness.dark));
    }

  }
}

