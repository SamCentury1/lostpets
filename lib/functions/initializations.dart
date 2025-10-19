import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/settings/settings.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Initializations {

  Future<void> initializeAppData(SettingsController settings, ColorPalette palette, User? user) async {
    Map<String,dynamic> userData = await FirestoreMethods().getFirestoreDocument(user!.uid);
    settings.setUserData(userData);

    List<Map<String,dynamic>> petData = await FirestoreMethods().getPetDocumentsFromDatabase(user!.uid);
    settings.setPetData(petData);

    // List<dynamic> urls = [];
    // for (int i=0; i<petData.length; i++) {
    //   Map<String,dynamic> petObject = petData[i];
    //   List<dynamic> media = petObject["media"];
    //   urls.addAll(media); 
    // }
    
    // print(petData);
    if (userData.isNotEmpty) {
      palette.selectTheme2(userData["parameters"]["theme"]);
    }
  } 

  // Future<void> preloadImages(BuildContext context, List<dynamic> urls) async {
  //   for (final url in urls) {
  //     await precacheImage(NetworkImage(url), context);
  //   }
  // }  

  // Future<void> preloadImagesToDiskCache(List<dynamic> urls) async {
  //   final cacheManager = DefaultCacheManager();
  //   for (final url in urls) {
  //     await cacheManager.downloadFile(url);
  //   }
  //   print("------------------ finished loading images ---------------");
  // }  

}