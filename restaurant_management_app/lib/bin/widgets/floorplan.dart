import 'package:flutter/material.dart';
import 'package:restaurant_management_app/bin/entities/table_list.dart';
import 'package:restaurant_management_app/bin/models/table_model.dart';
import 'package:restaurant_management_app/bin/services/table_service.dart';
import 'package:restaurant_management_app/bin/widgets/table_widget.dart';

/// Floor plan builder
class FloorPlan extends StatefulWidget {
  const FloorPlan({Key? key}) : super(key: key);

  @override
  State<FloorPlan> createState() => _FloorPlanState();
}

bool firstBuild = true;

class _FloorPlanState extends State<FloorPlan> {
  late BoxConstraints _tablesBoxConstraints;
  String dropdownValue = '2';
  List<MovableTable> _tables = [];
  List<TableModel> _tableModelList = []; //required for the first initialization of _tables
  bool read = false;

  @override
  void initState(){
    super.initState();
    init();
  }

  //separate function because it needs to be async
  Future<void> init() async{
    _tableModelList = await loadTables();
    setState(() {
      read = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 1 / 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ignore: avoid_unnecessary_containers
                Container(
                  // container is necessary bc. it groups the selector and button together
                  child: Row(
                    children: [
                      //table size selector
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['2', '3', '4', '6', '8']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      //add table button
                      FloatingActionButton(
                        onPressed: () => {addTable()},
                        child: const Icon(Icons.add),
                        backgroundColor: Colors.lightGreen,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Container for the displayed tables
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 7 / 8,
            child: LayoutBuilder(builder: (context, childConstraints) {
              _tablesBoxConstraints = childConstraints;

              if (read && firstBuild) {
                // load tables from somewhere on first build
                firstBuild = false;
                _tables = getWidgetsFromTables(
                    _tableModelList, childConstraints);
              }

              return Stack(
                children: _tables,
              );
            }),
          ),
        ],
      );
    });
  }

  /// Adds a new table widget to the table list
  ///
  void addTable() {
    setState(() {
      _tables.add(MovableTable(
          constraints: _tablesBoxConstraints,
          tableSize: int.parse(dropdownValue),
          position: Offset.zero,
          id: generateTableId(tableSize: int.parse(dropdownValue), tableWidgets: _tables),
      ));
    });
    TableList.setTableList(getTablesFromTableWidgets(_tables)); //update static TableList
    //TODO - decide if updates are inserted instantly
    //if not, this line needs to be removed
    saveTables(_tables);
  }
}
