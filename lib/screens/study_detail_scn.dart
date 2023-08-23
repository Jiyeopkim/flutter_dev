
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_sql/screens/result_scn.dart';

import '../controllers/sql_controller.dart';

class StudyDetailScn extends StatefulWidget {
  const StudyDetailScn({super.key});
  
  
  @override
  State<StatefulWidget> createState() => _StudyDetailScn();
}

class _StudyDetailScn extends State<StudyDetailScn> {

  double count = 0;
  SqlController cnt = Get.put(SqlController());
  int index = 1;

  void init() async {
    // 목록에서 id는 전달 받음.
    if(Get.arguments != null) {
      index = Get.arguments;
    }else
    {
    }
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
      appBar: AppBar(
        title: Text(cnt.sqlItem.value.title ?? 'SQL Statement'),
      ),
      body: 
      SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: false,
        maintainBottomViewPadding: false,
        child: Obx(() => cnt.isDataLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                cnt.sqlItem.value.syntax == null ? const SizedBox(height: 0,) :
                  Card(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(cnt.sqlItem.value.syntax ?? 'no data'),
                  )),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: InputDecorator(
                    decoration: 
                      const InputDecoration(
                        labelText: 'Explaination',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          // topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10), 
                          bottomRight: Radius.circular(10))
                        ),
                    ),
                    child: Text(cnt.sqlItem.value.explainEng ?? 'no data')
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: InputDecorator(
                    decoration: 
                      const InputDecoration(
                        labelText: '설명',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          // topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10), 
                          bottomRight: Radius.circular(10))
                        ),
                    ),
                    child: Text(cnt.sqlItem.value.explainKor ?? 'no data')
                  ),
                ),                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: cnt.examList.length,
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
                          title: Text(cnt.examList[index].title
                              .toString()),
                          subtitle: Text(cnt
                              .examList[index].id
                              .toString()),
                          onTap: () async {
                                  await cnt.execSql(cnt.examList[index].title as String);
                                  await Get.to(() => const ResultScn(), 
                                      fullscreenDialog: true, 
                                      transition: Transition.rightToLeft, 
                                      duration: const Duration(milliseconds: 300),
                                      arguments:cnt.examList[index].title);
                          },
                        ),
                    ),
                  );
                },
                ),
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Entry A')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: const Center(child: Text('Entry C')),
                ),
              ],
            )
        ),
    ),
    );
  }

}
