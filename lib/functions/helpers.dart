import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
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

  Map<String,dynamic> getPetObject(SettingsController settings, String petId) {
    // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
    List<dynamic> petData = settings.petData.value;    
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId,orElse: ()=><String,dynamic>{});
    return petObject;

  }


  String displayBreedDataLabel(List<String> breedData) {
    late String res = "";
    if (breedData.isEmpty) {
      res = "Unknown Breed";
    } else {
      if (breedData.length == 1) {
        res = breedData[0];
      } else {
        res = "Mix ${breedData[0]} & ${breedData[1]}";
      }
    }
    return res;
  }

  String displayAllowedOutside(bool allowedOutside) {
    String res = "";
    if (allowedOutside) {
      res = "Allowed outside alone";
    } else {
      res = "Not allowed outside alone";
    }
    return res;
  }



  Future<String?> getPostalCodeFromGeoPoint(GeoPoint? location) async {
    try {

      if (location != null) {
        print("LOCATION: $location");
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          String? res = place.subLocality; 
          if (place.subLocality == "") {
            res = place.locality;
          }
          return res; // ✅ Postal/ZIP code
        } else {
          return null;
        }
      } else {
        return "";
      }
    } catch (e) {
      print('Error getting postal code: $e');
      return null;
    }
  }  

  Future<String?> getAddressFromGeoPoint(GeoPoint location) async {
    
    try {
      String? res = null;
      print("LOCATION: $location");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        print("""
=================================
      administrativeArea:     ${place.administrativeArea}
      country:                ${place.country}
      hashCode:               ${place.hashCode}
      isoCountryCode:         ${place.isoCountryCode}
      locality:               ${place.locality}
      name:                   ${place.name}
      postalCode:             ${place.postalCode}
      street:                 ${place.street}
      subAdministrativeArea:  ${place.subAdministrativeArea}
      subLocality:            ${place.subLocality}
      subThoroughfare:        ${place.subThoroughfare}
      thoroughfare:           ${place.thoroughfare}
      runtimeType:            ${place.runtimeType}
=================================
""");


        // res = "${place.locality}, ${place.postalCode}"
        return "${place.street}, ${place.locality} ${place.administrativeArea} ${place.postalCode}"; // ✅ Postal/ZIP code
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting postal code: $e');
      return null;
    }
  }

  Future<String?> getAddressFromGeoPoint2(GeoPoint location) async {
    
    try {
      String? res = null;
      print("LOCATION: $location");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        // res = "${place.locality}, ${place.postalCode}"
        return "${place.street}, ${place.postalCode}"; // ✅ Postal/ZIP code
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting postal code: $e');
      return null;
    }
  }


  void updatePetLocationToSettings(SettingsController settings, String petId, GeoPoint location) {
    List<dynamic> petData = settings.petData.value;    
    Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId,orElse: ()=><String,dynamic>{});
    petObject.update('location', (v) => location);
    settings.setPetData(settings.petData.value);    

  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295; //conversion factor from radians to decimal degrees, exactly math.pi/180
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    var radiusOfEarth = 6371;
    return radiusOfEarth * 2 * asin(sqrt(a));
  }  

  
}