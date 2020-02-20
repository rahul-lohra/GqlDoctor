import 'dart:collection';

import 'package:example_flutter/presentation/data/ListItemData.dart';
import 'package:example_flutter/presentation/data/SqlDataType.dart';
import 'package:flutter/material.dart';

class TableData {
  int fieldCount;
  HashMap<TextEditingController, String> valueEditorSqlDataTypeMap;
  List<ListItemData> listOfListItemData;

  TableData(HashMap<String, String> columnNamesDataTypes) {
    listOfListItemData = List();
    prepareListOfListItemData(columnNamesDataTypes);
    this.fieldCount = listOfListItemData.length;
  }

  void prepareListOfListItemData( HashMap<String, String> columnNamesDataTypes){

    columnNamesDataTypes.forEach((String columnName, String columnDataType) {
      TextEditingController columnTextEditingController = TextEditingController();
      columnTextEditingController.text = columnName;

      TextEditingController valueTextEditingController = TextEditingController();

      listOfListItemData.add(ListItemData(columnTextEditingController, valueTextEditingController, columnDataType));
    });
  }

}
