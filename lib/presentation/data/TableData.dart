import 'dart:collection';

import 'package:example_flutter/presentation/data/ListItemData.dart';
import 'package:example_flutter/presentation/data/SqlDataType.dart';
import 'package:flutter/material.dart';

class TableData {
  int fieldCount;
  HashMap<TextEditingController, String> valueEditorSqlDataTypeMap;
  List<String> dropDownValue;
  List<ListItemData> listOfListItemData;

  TableData(int fieldCount, HashMap<String, String> columnNamesDataTypes) {
    this.fieldCount = fieldCount;

    listOfListItemData = List();
    dropDownValue = List(fieldCount);

    columnNamesDataTypes.forEach((String columnName, String columnDataType) {
      TextEditingController columnTextEditingController = TextEditingController();
      columnTextEditingController.text = columnName;

      TextEditingController valueTextEditingController = TextEditingController();

      listOfListItemData.add(ListItemData(columnTextEditingController, valueTextEditingController, columnDataType));
    });
  }
}
