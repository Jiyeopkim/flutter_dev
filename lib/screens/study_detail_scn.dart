
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
        title: Text(cnt.sqlItem.value.title ?? 'SQL Statement', style: const TextStyle(fontSize: 20),),
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
                cnt.sqlItem.value.simpleEng == null ? const SizedBox(height: 0,) :
                  Card(
                    elevation: 0,
                    child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(cnt.sqlItem.value.simpleEng ?? 'no data'),
                  )),
                cnt.sqlItem.value.simpleKor == null ? const SizedBox(height: 0,) :
                  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(cnt.sqlItem.value.simpleKor ?? 'no data'),
                  ),  
                const SizedBox(height: 10,),   
                cnt.examList.isEmpty ? const SizedBox(height: 0,) : // 예제가 있으면 표시                            
                Container(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: cnt.examList.length,
                    itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            Text('${index + 1}. ${cnt.examList[index].content ?? 'example'}'),
                            const SizedBox(height: 10,),
                            cnt.examList[index].contentKor == null ? const SizedBox(height: 0,) :
                            Column(
                              children: [
                                Text(cnt.examList[index].contentKor ?? 'example'),
                                const SizedBox(height: 10,),
                              ],
                            ),                            
                            SizedBox(
                              width: double.infinity,
                              child: Card(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(cnt.examList[index].title ?? 'no data'),
                              )),
                            ),
                            const SizedBox(height: 10,),
                            Center(
                              child: OutlinedButton(onPressed: () async {
                                  await cnt.execSql(cnt.examList[index].title as String);
                                  await Get.to(() => const ResultScn(), 
                                      fullscreenDialog: true, 
                                      transition: Transition.rightToLeft, 
                                      duration: const Duration(milliseconds: 300),
                                      arguments:cnt.examList[index].title);                                
                              }, 
                                child: const Text('Execute')),
                            ),
                        ],),
                    );
                  },
                  ),
                ),
                const SizedBox(height: 10,),
                cnt.sqlItem.value.explainEng == null ? const SizedBox(height: 0,) :
                Container(
                  padding: const EdgeInsets.all(3.0),
                  child: InputDecorator(
                    decoration: 
                      const InputDecoration(
                        labelText: 'Explanation',
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
                const SizedBox(height: 10,),   
                cnt.sqlItem.value.explainKor == null ? const SizedBox(height: 0,) :          
                Container(
                  padding: const EdgeInsets.all(3.0),
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
                const SizedBox(height: 10,),
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
