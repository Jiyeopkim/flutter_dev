
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';
import '../models/sql_model.dart';
import '../util.dart';

class QuizScn extends StatefulWidget {
  const QuizScn({super.key});
  
  
  @override
  State<StatefulWidget> createState() => _QuizScn();
}

class _QuizScn extends State<QuizScn> {
  QuizController quiz = Get.put(QuizController());
  RxBool isMade = false.obs;

  double count = 0;

  void init() async {
    changeStatusBarColor();
    await quiz.getNation();
    isMade.value = await quiz.getList(quiz.sqlItem.value.title ?? '');
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
          child:
          Padding(
                padding: const EdgeInsets.all(10),
                child: Obx(() => isMade.value == false
                    ? const Text('')
                    :

                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  <Widget>[
                                const SizedBox(height: 10),                 
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                        labelText: "수도이름 맞추기",
                                        border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          // topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15), 
                                          bottomRight: Radius.circular(15))
                                        ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Text("* Which of the following is a '${quiz.sqlItem.value.title}' description?"),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              makeAnser(quiz.sqlList[0]);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }
                                          },
                                          child: Text('➀ ${getSimple(0)}', ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              makeAnser(quiz.sqlList[1]);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }
                                          },
                                          child: Text('➁ ${getSimple(1)}', ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              makeAnser(quiz.sqlList[2]);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }                        
                                          },
                                          child: Text('➂ ${getSimple(2)}', ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              makeAnser(quiz.sqlList[3]);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }                         
                                          },
                                          child: Text('➃ ${getSimple(3)}', ),
                                        ), 
                                      ]),
                                    ),
                                  ),
                                ),  
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.center,
                                  child: OutlinedButton (
                                  onPressed: () async{
                                    isMade.value = false;
                                    await quiz.getNation();
                                    isMade.value = await quiz.getList(quiz.sqlItem.value.simpleEng ?? '');                    
                                  },
                                  
                                  child: const Text('다음문제'),
                                ),    
                                ), 
                                const SizedBox(height: 100),                                                    
                              ]
                            ),
                          ),
                      ]),
                    )
              )
          )
        )
      ),
    );
  }

  String? getSimple(int index)
  {
    try {
      return quiz.sqlList[index].simpleEng;
    } catch (e) {
      return '';
    }
  }

  void makeAnser(SqlModel value) async {
    if(value == quiz.sqlItem.value) {
      Get.snackbar('정답', '정답입니다.', duration: const Duration(seconds: 1), snackPosition: SnackPosition.bottom, 
        animationDuration: const Duration(milliseconds: 200), colorText: Colors.blue);

      isMade.value = false;
      await quiz.getNation();
      isMade.value = await quiz.getList(quiz.sqlItem.value.simpleEng ?? '');          
      
    } else {
      Get.snackbar('오답', '오답입니다.', duration: const Duration(seconds: 1), snackPosition: SnackPosition.bottom, 
        animationDuration: const Duration(milliseconds: 200), colorText: Colors.red);
    }
  }
}
