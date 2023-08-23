import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_sql/screens/stat_scn.dart';
import 'package:learn_sql/screens/study_detail_scn.dart';
import 'package:learn_sql/screens/study_scn.dart';
import 'package:learn_sql/screens/exec_scn.dart';

import 'controllers/the_app_controller.dart';
import 'screens/quiz_scn.dart';
import 'screens/result_scn.dart';
import 'the_app.dart';
import 'widget/custom_animated_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Learn SQL with SQLite',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _widgetOptions.elementAt(cnt.selectedIndex.value),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  final _inactiveColor = Colors.grey;

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
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.search),
          title: const Text('lesson'),
          activeColor: TheApp.highColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.list),
          title: const Text('exercise'),
          activeColor: TheApp.highColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.quiz),
          title: const Text(
            'quiz',
          ),
          activeColor: TheApp.highColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.people),
          title: const Text('profile'),
          activeColor: TheApp.highColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  //BottomNavigationBar 그리기, 아이콘 변경은 여기서...
  static List<BottomNavigationBarItem> getNavibar() {
    List<BottomNavigationBarItem> list = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.search, color: Colors.black87),
        activeIcon:
            Icon(Icons.search, color: TheApp.highColor),
        label: 'lesson',
        // backgroundColor: TheApp.backColor,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list, color: Colors.black87),
        activeIcon: Icon(Icons.list, color: TheApp.highColor),
        label: 'exercise',
        // backgroundColor: TheApp.backColor,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.quiz, color: Colors.black87),
        activeIcon: Icon(Icons.quiz, color: TheApp.highColor),
        label: 'quiz',
        // backgroundColor: TheApp.backColor,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people, color: Colors.black87),
        activeIcon:
            Icon(Icons.people, color: TheApp.highColor),
        label: 'myinfo',
        // backgroundColor: TheApp.backColor,
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
    cnt.title.value = getNavibar()[index].label!;
    cnt.selectedIndex.value = index;
    setState(() {});
  }
}
