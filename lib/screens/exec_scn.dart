import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sql_controller.dart';

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
                          controller: textEditingController,
                          focusNode: searchFocusNode,
                          onChanged: (value) {
                            // word?.value = value;
                          },
                          maxLines: 1,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            onExecPressed();
                          },
                          decoration: InputDecoration(
                            prefixIcon: IconButton(icon: const Icon(Icons.search), 
                              onPressed: () => setState(() {
                                // onWordPressed();
                              }),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                              hintText: 'Input SQL Statement',
                              labelText: 'SQL',
                              isDense: true,
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                // clearSearchInput();
                              }),
                              icon: const Icon(Icons.clear)),
                          ),
                        ),
                    TextButton(onPressed: onPressed, child: Text('Exec'),),
                    // ignore: unrelated_type_equality_checks
                    Obx(() => isExec == false ? 
                      const Expanded(child: Text('Hello, World')) :             
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              
                              PaginatedDataTable(
                                      source: getData(),
                                      header: const Text('SQL Result'),
                                      columns: getColumns,
                                      columnSpacing: 10,
                                      horizontalMargin: 10,
                                      rowsPerPage: 10,
                                      showCheckboxColumn: false,
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                  ),
                  // SizedBox(
                  //   height: 100,
                  //   child: Text(getColumn())),
                ],
              ),
            )
          )
        
      ),
    );
  }

  List<DataColumn> get getColumns {
    // 컬러명을 가져옴, 데이터 먼저 가져오고 컴럼명은 다음에 가져옴
    // 컬럼 개수와 데이터 필드의 개수가 일치해야함.
    List<DataColumn> columns = [];
    var keys = cnt.result.first.keys;
    for(var item in keys)
    {
      debugPrint(item.toString());
      columns.add(DataColumn(label: Text(item.toString())));
    }
    return columns;
  }
  
  void onExecPressed() async {
    await cnt.execSql(textEditingController.text);
    isExec?.value = true;
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

    List<Map<String, dynamic>> data = cnt.result;

    return MyData(data);
  }

  void onPressed() {
    print('Hello, Wrold');
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(List<Map<String, dynamic>> data)
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