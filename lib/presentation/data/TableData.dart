import 'dart:collection';

import 'package:example_flutter/presentation/data/SqlDataType.dart';
import 'package:flutter/material.dart';

class TableData {
  int fieldCount;
  List<TextEditingController> columnEditor;
  List<TextEditingController> valueEditor;
  HashMap<TextEditingController, SqlDataType> valueEditorSqlDataTypeMap;
  List<String> dropDownValue;

  TableData(int fieldCount, List<String> columnNames) {
    this.fieldCount = fieldCount;

    columnEditor = List(fieldCount);
    valueEditor = List(fieldCount);
    dropDownValue = List(fieldCount);
    for (int i = 0; i < fieldCount; ++i) {
      columnEditor[i] = TextEditingController();
      columnEditor[i].text = columnNames[i];
      valueEditor[i] = TextEditingController();
      dropDownValue[i] = "String";
    }
  }
}
