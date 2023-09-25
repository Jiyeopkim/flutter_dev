import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite3/src/result_set.dart';

import '../controllers/sql_controller.dart';
import 'result_scn.dart';

class ExecScn extends StatefulWidget {
  const ExecScn({super.key});
  
  @override
  State<StatefulWidget> createState() => _ExecScn();
}

class _ExecScn extends State<ExecScn> {
  SqlController cnt = Get.put(SqlController());
  TextEditingController textEditingController = TextEditingController(text: "select * from Customers");
  FocusNode? searchFocusNode;

  RxBool? isExec= false.obs;
  double count = 0;

  void init() async {
    searchFocusNode = FocusNode();
  }

  void cleanUp() {
    searchFocusNode?.dispose();
  }

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
              padding: const EdgeInsets.all(8.0),
              child: 
              Column(
                children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                          minLines: 1,//Normal textInputField will be displayed
                          maxLines: 10,// when user presses enter it will adapt to it
                          controller: textEditingController,
                          focusNode: searchFocusNode,
                          onChanged: (value) {
                            // word?.value = value;
                          },
                          // textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            onExecPressed();
                          },
                          decoration: InputDecoration(
                            prefixIcon: IconButton(icon: const Icon(Icons.play_arrow), 
                              onPressed: () => setState(() {
                                onExecPressed();
                              }),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                              hintText: 'Input SQL Statement',
                              labelText: 'SQL',
                              isDense: true,
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                  clearSearchInput();
                              }),
                              icon: const Icon(Icons.clear)),
                          ),
                        ),
                    const SizedBox(height: 10,),
                    OutlinedButton(onPressed: onPressed, child: const Text('Run SQL'),),
                    const SizedBox(height: 10,),
                    Text('Sample Database Tables', style: Theme.of(context).textTheme.titleMedium,),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: 
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 10,
                          children: <Widget>[
                            getTableChip('Customers'),
                            getTableChip('Products'),
                            getTableChip('Employees'),
                            getTableChip('Orders'),
                            getTableChip('Order Details'),
                            getTableChip('Shippers'),
                            getTableChip('Suppliers'),
                            getTableChip('Categories'),
                            getTableChip('Regions'),
                            getTableChip('Territories'),
                            getTableChip('EmployeeTerritories'),
                          ])
                        ),
                      ),
                    
                ],
              ),
            )
          )
        
      ),
    );
  }

  Widget getTableChip(String tableName)
  {
    return ActionChip(
      label: Text(tableName),
      onPressed: () async {
        bool isSuccess = await cnt.execSql('select * from "$tableName"');

        if(isSuccess){
          await Get.to(() => const ResultScn(), 
              fullscreenDialog: true, 
              transition: Transition.rightToLeft, 
              duration: const Duration(milliseconds: 300),
              arguments:'select * from "$tableName"');                                
        }

      });
  }

  List<DataColumn> get getColumns {
    // 컬러명을 가져옴, 데이터 먼저 가져오고 컴럼명은 다음에 가져옴
    // 컬럼 개수와 데이터 필드의 개수가 일치해야함.
    List<DataColumn> columns = [];
    var keys = cnt.result?.columnNames;
    for(var item in keys!)
    {
      debugPrint(item.toString());
      columns.add(DataColumn(label: Text(item.toString())));
    }
    return columns;
  }
  
  void onExecPressed() async {
    bool isSuccess = await cnt.execSql(textEditingController.text);

    if(isSuccess){
      await Get.to(() => const ResultScn(), 
          fullscreenDialog: true, 
          transition: Transition.rightToLeft, 
          duration: const Duration(milliseconds: 300),
          arguments:textEditingController.text);                                
    }
  }
  
  getData() {

    // List<Map<String, dynamic>> _data = List.generate(
    //     200,
    //     (index) => {
    //           "id": index,
    //           "title": "Item $index",
    //           "title2": "Item $index",
    //           "price": Random().nextInt(10000)
    //         });

    ResultSet? data = cnt.result;

    return MyData(data!);
  }

  void onPressed() async {
    bool isSuccess = await cnt.execSql(textEditingController.text);

    if(isSuccess){
      await Get.to(() => const ResultScn(), 
          fullscreenDialog: true, 
          transition: Transition.rightToLeft, 
          duration: const Duration(milliseconds: 300),
          arguments:textEditingController.text);                                
    }
  }
  
  void clearSearchInput() {
    textEditingController.clear();
    // word?.value = '';
    searchFocusNode?.requestFocus();
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(ResultSet data)
  {
    debugPrint('MyData');
    _data = data;
    
    // 쿼리 결과를 테이블에 넣기 위해 DataRow로 변환
    dataRows = [];
    for(var item in _data)
    {
      var dataRow = DataRow(cells: []);

      for(var subitem in item.values)
      {
        // 내용이 너무 길면 30자로 자로 자르고, 셀의 폭을 고정함.
        if(subitem.toString().length > 30) {
          dataRow.cells.add(DataCell(SizedBox(width: 150, child: Text(subitem.toString(), overflow: TextOverflow.ellipsis,))));
        } else {
          dataRow.cells.add(DataCell(Text(subitem.toString())));
        }
        // dataRow.cells.add(DataCell(SizedBox(width: 150, child: Text(subitem.toString(), overflow: TextOverflow.ellipsis,))));
      }
      dataRows.add(dataRow);
    }
  }
  late List<Map<String, dynamic>>_data;
  late List<DataRow> dataRows;

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return dataRows[index];
  }
}