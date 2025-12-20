import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';

class StorageMethods {

  Future<void> saveDeviceSizeInfoToSettings(SettingsController settings) async {
    // First get the FlutterView.
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;

    print("----------------- ${view.physicalSize} --------------------");
    double width = size.width;
    double height = size.height;
    final double standardHeight = 890;
    final double scalor = height/standardHeight;

    Object deviceSizeInfo = {
      "width": width,
      "height":height,
      "scalor":scalor,
    };
    settings.setDeviceSizeInfo(deviceSizeInfo);
  }  


  Future<void> saveRequestDataToLocalStorage(SettingsController settings) async {
    Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    // List<dynamic> requests = userData["notifications"];
    List<Map<String,dynamic>> requestDocuments = await FirestoreMethods().retrieveRequestDocuments(userData["uid"]);
    settings.setRequestsData(requestDocuments);
  }
}