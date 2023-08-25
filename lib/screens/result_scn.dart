import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sql_controller.dart';

class ResultScn extends StatefulWidget {
  const ResultScn({super.key});
  
  @override
  State<StatefulWidget> createState() => _ResultScn();
}

class _ResultScn extends State<ResultScn> {
  SqlController cnt = Get.put(SqlController());
  TextEditingController textEditingController = TextEditingController(text: "select * from Customers");
  FocusNode? searchFocusNode;

  RxBool? isExec= false.obs;
  double count = 0;
  String sqlStatment = 'select * from Customers';

  void init() async {
    searchFocusNode = FocusNode();

    // 목록에서 id는 전달 받음.
    if(Get.arguments != null) {
      sqlStatment = Get.arguments;
      isExec?.value = true;
      // setState(() {});
    }else
    {
    }
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
      appBar: AppBar(
        title: const Text('SQL Result', style: TextStyle(fontSize: 20),),
      ),
      body: 
      SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: false,
        maintainBottomViewPadding: false,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: 
          Obx(() => isExec == false ? 
            const Expanded(child: Text('No Data')) :             
            SingleChildScrollView(
              child: PaginatedDataTable(
                      source: getData(),
                      header: Text(sqlStatment, style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),
                      columns: getColumns,
                      columnSpacing: 10,
                      horizontalMargin: 10,
                      rowsPerPage: 8,
                      showCheckboxColumn: false,
              ),
            ),
              ),
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
        if(subitem.toString().length > 30) {
          dataRow.cells.add(DataCell(SizedBox(width: 150, child: Text(subitem.toString(), overflow: TextOverflow.ellipsis,))));
        } else {
          dataRow.cells.add(DataCell(Text(subitem.toString())));
        }
        //dataRow.cells.add(DataCell(SizedBox(width: 150, child: Text(subitem.toString(), overflow: TextOverflow.ellipsis,))));
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