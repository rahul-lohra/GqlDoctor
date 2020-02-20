class ColumnNameUseCase{

  List<String> getAllowedColumnNames(){
    List<String> gqlColumns = ['response','enabled','gqlOperationName','customTag'];
    List<String> restColumns = ['response','enabled','httpMethod','url'];
    gqlColumns.addAll(restColumns);
    return gqlColumns;
  }
}