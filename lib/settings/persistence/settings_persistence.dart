abstract class SettingsPersistence {
  /// ========== GET THE DATA ===================
  Future<Object> getDeviceSizeInfo();  

  Future<String> getTheme();

  Future<Object> getUserData();

  Future<List<dynamic>> getPetData();  

  Future<List<dynamic>> getRequestsData();    



  /// ========== SAVE THE DATA ===================
  Future<void> saveDeviceSizeInfo(Object value);
  
  Future<void> saveTheme(String value);  

  Future<void> saveUserData(Object value);

  Future<void> savePetData(List<dynamic> value);

  Future<void> saveRequestsData(List<dynamic> value);  

}
