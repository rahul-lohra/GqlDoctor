import 'dart:convert';

class GetPrettyJsonUseCase{

  String getPrettyJson(String json){
    String prettyJson = JsonEncoder.withIndent('    ').convert(JsonDecoder().convert(json));
    return prettyJson;
  }

}