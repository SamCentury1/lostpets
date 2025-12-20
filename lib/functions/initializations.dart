import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tempoct2025/providers/palette_state.dart';
import 'package:tempoct2025/resources/firestore_methods.dart';
import 'package:tempoct2025/resources/storage_methods.dart';
import 'package:tempoct2025/settings/settings.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Initializations {

  Future<void> initializeAppData(SettingsController settings, User? user) async {
    
    await _ensureLocationPermission();

    Map<String,dynamic> userData = await FirestoreMethods().getFirestoreDocument(user!.uid);
    settings.setUserData(userData);

    List<Map<String,dynamic>> petData = await FirestoreMethods().getPetDocumentsFromDatabase(user!.uid);
    settings.setPetData(petData);

    // sync the user doc's requests
    StorageMethods().saveRequestDataToLocalStorage(settings);

    // List<dynamic> urls = [];
    // for (int i=0; i<petData.length; i++) {
    //   Map<String,dynamic> petObject = petData[i];
    //   List<dynamic> media = petObject["media"];
    //   urls.addAll(media); 
    // }
    
    // print(petData);
    // if (userData.isNotEmpty) {
    //   palette.selectTheme2(userData["parameters"]["theme"]);
    // }
  } 


  Future<void> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // If user permanently denies, still continue — but GoogleMap disables myLocation gracefully
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