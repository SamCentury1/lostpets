import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tempoct2025/settings/persistence/settings_persistence.dart';

class SettingsController {
  final SettingsPersistence _persistence;
  ValueNotifier<Object> deviceSizeInfo = ValueNotifier({});
  ValueNotifier<String> theme = ValueNotifier("default");  
  ValueNotifier<Object> userData = ValueNotifier({});
  ValueNotifier<List<dynamic>> petData = ValueNotifier([]);



  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  /// Asynchronously loads values from the injected persistence store.

  Future<void> loadStateFromPersistence() async {
    await Future.wait([ // await
      _persistence.getDeviceSizeInfo().then((value)=>deviceSizeInfo.value = value),
      _persistence.getTheme().then((value) => theme.value = value),
      _persistence.getUserData().then((value) => userData.value = value),
      _persistence.getPetData().then((value) => petData.value = value),
      // _persistence.getColorTheme().then((value) => colorTheme.value = value),

    ]);
  }

  void setDeviceSizeInfo(Object value) {
    deviceSizeInfo.value = value;
    _persistence.saveDeviceSizeInfo(deviceSizeInfo.value);    
  }  


  void setTheme(String value) {
    theme.value = value;
    _persistence.saveTheme(theme.value);
  }  


  void setUserData(Object value) {
    userData.value = value;
    _persistence.saveUserData(userData.value);
  }  

  void setPetData(List<dynamic> value) {
    petData.value = value;
    _persistence.savePetData(petData.value);
  }

}
