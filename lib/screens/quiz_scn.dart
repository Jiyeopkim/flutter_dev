
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
    isMade.value = await quiz.getQuiz();
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
                                        labelText: "Quiz",
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
                                        Text("• Which of the following is a '${quiz.sqlItem.value.title}' ${quiz.description}?"),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: () {
                                            try {
                                              makeAnser(quiz.sqlList[0]);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }
                                          },
                                          child: Text('(a) ${getSimple(0)}', ),
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
                                          child: Text('(b) ${getSimple(1)}', ),
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
                                          child: Text('(c) ${getSimple(2)}', ),
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
                                          child: Text('(d) ${getSimple(3)}', ),
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
                                    isMade.value = await quiz.getQuiz();                    
                                  },
                                  
                                  child: const Text('Next'),
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
      // Get.snackbar('정답', '정답입니다.', duration: const Duration(seconds: 1), snackPosition: SnackPosition.bottom, 
      //   animationDuration: const Duration(milliseconds: 200), colorText: Colors.blue);
      // Get.dialog( 
      //   AlertDialog(
      //     title: const Text('Correct'),
      //     content: Text('Correct Answer. ${quiz.sqlItem.value.title}: ${quiz.sqlItem.value.simpleEng}'),
      //     actions: [
      //       TextButton(
      //         child: const Text("Next"),
      //         onPressed: () async => 
      //         {
      //           Get.back(),
      //           isMade.value = false,
      //           await quiz.getNation(),
      //           isMade.value = await quiz.getList(quiz.sqlItem.value.simpleEng ?? ''),  
      //         }
      //       ),
      //     ],
      //   ),
      // );

      Get.bottomSheet(
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: SingleChildScrollView(
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Correct',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Correct Answer. ${quiz.sqlItem.value.title}: ${quiz.sqlItem.value.simpleEng}'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      
                      isMade.value = false;
                      isMade.value = await quiz.getQuiz();  
                      
                      Get.back();
                    },
                    child: const Text('Next'),
                  )
                ],
              ),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        backgroundColor: Theme.of(context).dialogBackgroundColor);        
      
    } else {
      Get.snackbar('Incorrect', 'Incorrect Answer.', duration: const Duration(seconds: 1), snackPosition: SnackPosition.bottom, 
        animationDuration: const Duration(milliseconds: 200), colorText: Colors.red);
    }
  }
}
