import 'dart:io';

class GetAdbUseCase{

  String getAdbPath(){
    String baseFolder = "android-platform-tools";
    String pathSuffix = "platform-tools/adb";
    if (Platform.isMacOS) {
      return baseFolder +
          "/" +
          "platform-tools_r29.0.5-darwin" +
          "/" +
          pathSuffix;
    } else if (Platform.isLinux) {
      return baseFolder +
          "/" +
          "platform-tools_r29.0.5-linux" +
          "/" +
          pathSuffix;
    } else if (Platform.isWindows) {
      return baseFolder +
          "/" +
          "platform-tools_r29.0.5-windows" +
          "/" +
          pathSuffix;
    }
    return "";
  }
}