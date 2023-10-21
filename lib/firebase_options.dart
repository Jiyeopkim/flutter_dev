// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDhfCOx1gZbw2hKWLKFHeqIWL0RUN-JzAM',
    appId: '1:966915652648:web:bbe8dbee8bb93594ef091d',
    messagingSenderId: '966915652648',
    projectId: 'sqlmaster-dee70',
    authDomain: 'sqlmaster-dee70.firebaseapp.com',
    storageBucket: 'sqlmaster-dee70.appspot.com',
    measurementId: 'G-VD3QFNKNCB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoSPgkoppzRX_SLqotnTurI111KvExUiw',
    appId: '1:966915652648:android:a3b18ab3ab1e5474ef091d',
    messagingSenderId: '966915652648',
    projectId: 'sqlmaster-dee70',
    storageBucket: 'sqlmaster-dee70.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsUoKXWIvtA1CFgHnkdSIzG5Kahao98ms',
    appId: '1:966915652648:ios:e0eda7da4530a79bef091d',
    messagingSenderId: '966915652648',
    projectId: 'sqlmaster-dee70',
    storageBucket: 'sqlmaster-dee70.appspot.com',
    iosBundleId: 'com.jykim.learnSql',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBsUoKXWIvtA1CFgHnkdSIzG5Kahao98ms',
    appId: '1:966915652648:ios:408b66ae54e81d93ef091d',
    messagingSenderId: '966915652648',
    projectId: 'sqlmaster-dee70',
    storageBucket: 'sqlmaster-dee70.appspot.com',
    iosBundleId: 'com.example.learnSql.RunnerTests',
  );
}
