import 'dart:collection';
import 'dart:io';

class SharedPreference {
  final File file;
  final HashMap<Object,Object> hashMap = new HashMap();

  SharedPreference(this.file);

  void putInt(String key, int value){
    hashMap[key] = value;
  }
  void putDouble(String key, double value){
    hashMap[key] = value;
  }
  void putString(String key, String value){
    hashMap[key] = value;
  }
  void putBoolean(String key, bool value){
    hashMap[key] = value;
  }

  getInt(){}
  getDouble(){}
  getString(){}
  getBoolean(){}

  void apply(){
    String content = file.readAsStringSync();
    hashMap.forEach((key,value)=>{

    });
    hashMap.clear();
  }

}

class SharedPreferenceProvider{
  final String defaultName = "SharedPreference.g";

  SharedPreference getSharedPreference({String name}) {
    String fileName = name;
    if (name == null) {
      fileName = defaultName;
    }
    String generatedFileName = fileName + ".g";
    File file = File(generatedFileName);
    return SharedPreference(file);
  }
}