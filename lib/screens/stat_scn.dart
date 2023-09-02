
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';


class StatScn extends StatefulWidget {
  const StatScn({super.key});
  
  
  @override
  State<StatefulWidget> createState() => _StatScn();
}

class _StatScn extends State<StatScn> {

  double count = 0;
  PackageInfo? packageInfo;
  void init() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      
    });
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
    return Scaffold(
      body: 
      SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: false,
        maintainBottomViewPadding: false,
        child: RefreshIndicator(
          onRefresh: () async { 
            // await quiz.getWordByLocal();
            // isMade.value = await quiz.getWordList(quiz.word.value.word ?? 'intutitive');
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              Text('Version ${packageInfo?.version}')
          ]),
        ),
      ),
    );
  }

}
