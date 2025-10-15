import 'package:tempoct2025/settings/settings.dart';

class Helpers {
  double getScalor(SettingsController settings) {
    late double res = 1.0;
    final Map<dynamic,dynamic> deviceSizeData = settings.deviceSizeInfo.value as Map<dynamic,dynamic>;
    res = deviceSizeData["scalor"]??1.0;
    return res;  
  }


  int calculateAge(int birthYear) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int age = currentYear-birthYear;
    return age;
  }  
}