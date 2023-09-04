import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:learn_sql/screens/stat_scn.dart';
import 'package:learn_sql/screens/study_detail_scn.dart';
import 'package:learn_sql/screens/study_scn.dart';
import 'package:learn_sql/screens/exec_scn.dart';

import 'controllers/the_app_controller.dart';
import 'screens/quiz_scn.dart';
import 'screens/result_scn.dart';
import 'util.dart';
import 'widget/custom_animated_bottom_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Learn SQL',
      theme: ThemeData(useMaterial3: true,
          colorSchemeSeed: Colors.deepOrangeAccent, 
          // colorScheme: lightColorScheme, 
          brightness: Brightness.light,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        )),
      darkTheme: ThemeData(useMaterial3: true, 
        colorSchemeSeed: Colors.deepOrangeAccent, 
        // colorScheme: darkColorScheme,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
        )),

      home: const MyHomePage(title: 'Learn SQL'),
      getPages: [
        GetPage(name: '/', page: () => const MyHomePage(title: 'Learn SQL')),
        GetPage(name: '/study', page: () => const StudyScn()),
        GetPage(name: '/exec', page: () => const ExecScn()),
        GetPage(name: '/quiz', page: () => const QuizScn()),
        GetPage(name: '/stat', page: () => const StatScn()),
        GetPage(name: '/study_detail', page: () => const StudyDetailScn()),
        GetPage(name: '/result', page: () => const ResultScn()),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TheAppController cnt = Get.put(TheAppController());

  void init() {
    changeStatusBarColor();
    // debugPrint(login.token);
  }

  void cleanUp() {}

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    cleanUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        centerTitle: true,
        title: Text(
                cnt.title.value,
                style: Theme.of(context).textTheme.titleLarge,
              ),
        elevation: 0,
      ),
      body: _widgetOptions.elementAt(cnt.selectedIndex.value),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  //아이콘 변경은 여기도 해야함.
  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      // backgroundColor: Colors.black,
      selectedIndex: cnt.selectedIndex.value,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: _onItemTapped,
      items: getNavibar(),
    );
  }

  //BottomNavigationBar 그리기, 아이콘 변경은 여기서...
  List<BottomNavyBarItem> getNavibar() {
    List<BottomNavyBarItem> list = 
    <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.book),
          title: const Text('lesson'),
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).disabledColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.list),
          title: const Text('exercise'),
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).disabledColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.quiz),
          title: const Text(
            'quiz',
          ),
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).disabledColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.people),
          title: const Text('myinfo'),
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).disabledColor,
          textAlign: TextAlign.center,
        ),
      ];
    return list;
  }

  //BottomNavigationBarItem에 연결할 화면들
  static const List<Widget> _widgetOptions = <Widget>[
    StudyScn(),
    ExecScn(),
    QuizScn(),
    StatScn()
  ];

  void _onItemTapped(int index) {
    cnt.title.value = (getNavibar()[index].title as Text).data!;
    cnt.selectedIndex.value = index;
    setState(() {});
  }
}
