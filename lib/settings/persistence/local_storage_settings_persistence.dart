
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempoct2025/settings/persistence/settings_persistence.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.

class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture = SharedPreferences.getInstance();

  /// ========= GET THE DATA =================

  @override
  Future<Object> getDeviceSizeInfo() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("deviceSizeInfo")??json.encode({}));
  }  

  @override
  Future<String> getTheme() async {
    final prefs = await instanceFuture;
    return prefs.getString('theme') ?? "default";
  }  

  @override
  Future<Object> getUserData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("userData")??json.encode({}));
  }

  @override
  Future<List<dynamic>> getPetData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("petData")??json.encode([]));
  }  



  /// ========= SAVE THE DATA =================
  @override
  Future<void> saveDeviceSizeInfo(Object value) async {
    final prefs = await instanceFuture;
    prefs.setString("deviceSizeInfo", json.encode(value)); 
  }

  @override
  Future<void> saveTheme(String value) async {
    final prefs = await instanceFuture;
    await prefs.setString('theme', value);
  }  


  @override
  Future<void> saveUserData(Object value) async {
    final prefs = await instanceFuture;
    prefs.setString("userData", json.encode(value)); 
  }     


  @override
  Future<void> savePetData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    final serializableList = value.map((item) {
      if (item is Map<String, dynamic>) {
        return item.map((key, val) {
          if (val is GeoPoint) {
            return MapEntry(key, {
              'latitude': val.latitude,
              'longitude': val.longitude,
            });
          }
          return MapEntry(key, val);
        });
      }
      return item;
    }).toList();
    prefs.setString("petData", json.encode(serializableList)); 
  }       


}
