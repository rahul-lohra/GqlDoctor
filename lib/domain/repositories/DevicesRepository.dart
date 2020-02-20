import 'dart:async';
import 'dart:io';

class DevicesRepository {
  
  Future<ProcessResult> getConnectedDevices() async{
    Future<ProcessResult> result =  Process.run('adb', ['devices']);
    return result;
  }

  Future<ProcessResult> getPackagesWhereLibraryIsInstalled() async{
    Future<ProcessResult> result =  Process.run('adb', ['devices']);
    return result;
  }
    
}
