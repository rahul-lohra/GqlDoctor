import 'dart:collection';

import 'package:example_flutter/presentation/data/ListItemData.dart';
import 'package:example_flutter/presentation/data/TableData.dart';
import 'package:flutter/material.dart';

class UpdateTableData extends TableData {

  UpdateTableData(HashMap<String, String> columnNamesDataTypes)
      :super(columnNamesDataTypes);

  @override
  void prepareListOfListItemData(HashMap<String, String> columnNamesDataTypes) {
    columnNamesDataTypes.forEach((String columnName, String columnDataType) {
      TextEditingController columnTextEditingController = TextEditingController();
      if (columnName == 'url' || columnName == 'gqlOperationName' || columnName == 'customTag') {
        columnTextEditingController.text = columnName;

        TextEditingController valueTextEditingController = TextEditingController();

        listOfListItemData.add(ListItemData(columnTextEditingController, valueTextEditingController, columnDataType));
      }
    });
  }
}