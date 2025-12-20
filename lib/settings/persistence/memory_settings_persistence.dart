
import 'package:tempoct2025/settings/persistence/settings_persistence.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.

class MemoryOnlySettingsPersistence implements SettingsPersistence {
  
  Object deviceSizeInfo = {};
  String theme = 'default';
  Object userData = {};
  List<dynamic> petData = [];
  bool isEditView = false;
  List<dynamic> requestsData = [];


  /// ============= GET ===================
  @override
  Future<Object> getDeviceSizeInfo() async => deviceSizeInfo;   

  @override
  Future<String> getTheme() async => theme;    

  @override
  Future<Object> getUserData() async => userData;

  @override
  Future<List<dynamic>> getPetData() async => petData; 

  @override
  Future<List<dynamic>> getRequestsData() async => requestsData;   



  /// =========== SAVE ========================


  @override
  Future<void> saveTheme(String value) async => theme = value;    

  @override
  Future<void> saveUserData(Object value) async => userData = value;
  
  @override
  Future<void> saveDeviceSizeInfo(Object value) async => deviceSizeInfo = value;  
  
  @override
  Future<void> savePetData(List<dynamic> value) async => petData = value;

  @override
  Future<void> saveRequestsData(List<dynamic> value) async => requestsData = value;
}