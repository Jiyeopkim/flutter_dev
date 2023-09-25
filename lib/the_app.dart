// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class TheApp {
  TheApp._();

  static String appName = 'Learn SQL';

  static String baseUrl = 'http://lucyw.azurewebsites.net';

  static bool isMobile = true;
  static bool isKorean = false;

  static const Color backColor = Color(0xFFF9F9F9);
  static const Color backColor500 = Color(0xAA008577);
  static const Color backColor100 = Color(0x40008577);
  static const Color highColor = Color(0xFF009591);
  static const Color textColor = Color(0xFF000000);
  static String highFont = 'GyeonggiMedium';

  static const MaterialColor myColor = MaterialColor(
    _myColorPrimaryValue,
    <int, Color>{
      50: Color(0xFFECEFF1),
      100: Color(0xFFCFD8DC),
      200: Color(0xFFB0BEC5),
      300: Color(0xFF90A4AE),
      400: Color(0xFF78909C),
      500: Color(_myColorPrimaryValue),
      600: Color(0xFF546E7A),
      700: Color(0xFF455A64),
      800: Color(0xFF37474F),
      900: Color(0xFF263238),
    },
  );
  static const int _myColorPrimaryValue = 0xFFA7E6D7;

  // static Future<bool> getIsMobile() async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     // I am connected to a mobile network.
  //     isMobile = true;
  //     return true;
  //   } else {
  //     // I am connected to a wifi network.
  //     isMobile = false;
  //     return false;
  //   }
  // }

  static const apiKey = "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";
  
}

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}