import 'dart:collection';
import 'dart:io';

class SharedPreference {
  final File _file;
  final HashMap<Object, Object> _readerMap = new HashMap();
  final HashMap<Object, Object> _writerMap = new HashMap();

  SharedPreference(this._file);

  void putInt(String key, int value) {
    _writerMap[key] = value;
  }

  void putDouble(String key, double value) {
    _writerMap[key] = value;
  }

  void putString(String key, String value) {
    _writerMap[key] = value;
  }

  void putBoolean(String key, bool value) {
    _writerMap[key] = value;
  }

  getInt(String key) {
    getPos(key);
  }

  RegexPos getPos(String key){

    String fileContent = _file.readAsStringSync();
    String startPattern = "<$key>";
    String endPattern = "</$key>";

    int startIndex = fileContent.indexOf(startPattern);
    int endIndex = fileContent.indexOf(endPattern);
    return RegexPos(startIndex, endIndex);
    // bool noMatchFound = startIndex == 0 && endIndex == 0; 
    // if(noMatchFound){
    //     return RegexPos(0, 0);
    // }else{
    //   int sPos = iterableStart.first.start;
    //   int ePos = iterableEnd.first.start;
    //   return RegexPos(sPos, ePos);
    // }
  }

  getDouble(String key) {}

  getString(String key) {}

  getBoolean(String key) {}

  void apply() {
    String content = _file.readAsStringSync();
    StringBuffer sb = StringBuffer(content);
    _writerMap.forEach((key,value){
      print('$key:$value');
      RegexPos regexPos = getPos(key);
      bool noMatchFound = (regexPos.startPoint == 0 && regexPos.endPoint == 0);
      if(noMatchFound){
        sb.writeln("<$key>$value</$key>");
      }else{
        print("Mactch found");
      }
    });
    _file.writeAsStringSync(sb.toString(),flush: true);

    _writerMap.clear();
  }
}

class RegexPos{
  final int startPoint;
  final int endPoint;

  RegexPos(this.startPoint, this.endPoint);

}
class SharedPreferenceProvider {
  static final String _defaultName = "SharedPreference";

  static SharedPreference getSharedPreference({String name}) {
    String fileName = name;
    if (name == null) {
      fileName = _defaultName;
    }
    String generatedFileName = fileName + ".g.txt" ;
    File file = File(generatedFileName);
   if(!file.existsSync()){
      file.createSync();
   }
    
    return SharedPreference(file);
  }
}
