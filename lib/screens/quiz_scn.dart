
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizScn extends StatefulWidget {
  const QuizScn({super.key});
  
  
  @override
  State<StatefulWidget> createState() => _QuizScn();
}

class _QuizScn extends State<QuizScn> {

  double count = 0;

  void init() async {
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
          child: Text('quiz not implemented'),
        ),
      ),
    );
  }

}
