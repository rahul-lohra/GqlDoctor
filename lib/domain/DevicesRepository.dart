import 'dart:async';
import 'dart:io';

class DevicesRepository {
  
  Future<ProcessResult> getConnectedDevices() {
    Future<ProcessResult> result =  Process.run('adb', []);
    return result;
  }
    
}
