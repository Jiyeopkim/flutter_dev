
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_sql/controllers/sql_controller.dart';
import 'package:learn_sql/screens/study_detail_scn.dart';

import '../the_app.dart';

class StudyScn extends StatefulWidget {
  const StudyScn({super.key});
  
  @override
  State<StatefulWidget> createState() => _StudyScn();
}

class _StudyScn extends State<StudyScn> {
  SqlController cnt = Get.put(SqlController());
  double count = 0;

  void init() async {
    cnt.getList();
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
          child:  Obx(
        () => cnt.isDataLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: cnt.sqlList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Material(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black).withAlpha(50), width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                      child: 
                        ListTile(
                          isThreeLine: false,
                          minLeadingWidth: 0,

                          leading: Text(cnt.sqlList[index].id.toString(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor),),
                          title: Text(cnt.sqlList[index].title
                              .toString()),
                          subtitle: Text(cnt
                              .sqlList[index].simpleEng
                              .toString(), overflow: TextOverflow.ellipsis,),
                          trailing:
                              // const Icon(Icons.arrow_forward_outlined),
                              IconButton(
                                  icon: const Icon(Icons.arrow_forward_outlined),
                                  tooltip: 'Go to details',
                                  onPressed: () async{
                                    await cnt.getItem(cnt.sqlList[index].id as int);
                                    await cnt.getExamList(cnt.sqlList[index].id as int);
                                    await Get.to(() => const StudyDetailScn(), 
                                      fullscreenDialog: true, 
                                      transition: Transition.downToUp, 
                                      duration: const Duration(milliseconds: 300),
                                      arguments:cnt.sqlList[index].id);
                                  },
                          ),                            
                        ),
                    ),
                  );
                },
              ),
          ),
        ),
      ),
    );
  }
}
