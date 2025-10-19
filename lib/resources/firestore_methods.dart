import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/settings/settings.dart';

class FirestoreMethods {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<Map<String,dynamic>> getFirestoreDocument(String uid) async {
    late DocumentSnapshot<Map<String,dynamic>> docStream;
    docStream = await _firestore.collection("users").doc(uid).get();
    return docStream.data() as Map<String, dynamic>;
  } 


  Future<List<Map<String,dynamic>>> getPetDocumentsFromDatabase(String uid) async {
    List<Map<String,dynamic>> petData = [];
    try {
      late DocumentSnapshot<Map<String,dynamic>> docStream;
      docStream = await _firestore.collection("users").doc(uid).get();
      Map<String,dynamic> userData = docStream.data() as Map<String, dynamic>;
      List<dynamic> petIds = userData["pets"];

      
      for (String petId in petIds) {
        DocumentSnapshot<Map<String,dynamic>> petDocStream;
        petDocStream = await _firestore.collection("pets").doc(petId).get();
        print(petDocStream.data());
        Map<String,dynamic> petObject = petDocStream.data() as Map<String, dynamic>;
        petData.add(petObject);
      } 
    } catch (e,s) {
      print("error: $e | stacktrace: $s");
    }
    return petData;
  }



// Future<String?> uploadPetImage(File imageFile, String petId) async {
//   try {
//     // Create a reference to your storage bucket
//     final storageRef = FirebaseStorage.instance.ref();

//     // Folder: "pet_images/<petId>.jpg"
//     final petImageRef = storageRef.child('pet_images/$petId.jpg');

//     // Upload file
//     await petImageRef.putFile(imageFile);

//     // Get the public download URL
//     final downloadURL = await petImageRef.getDownloadURL();
//     return downloadURL;
//   } catch (e) {
//     print("Error uploading image: $e");
//     return null;
//   }
// }

  Future<void> removePetMedia(String petId, String imageUrl) async {
    final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final List media = List.from(snapshot['media'] ?? []);
      media.remove(imageUrl);

      transaction.update(docRef, {'media': media});
    });
  }


  Future<void> updatePetMedia( String petId, List<String> newUrls) async {

    try {
      final docRef = _firestore.collection('pets').doc(petId);
      await docRef.update({
        'media': FieldValue.arrayUnion(newUrls),
      }).then((_) {
        debugPrint("✅ Pet media updated successfully!");
      }).catchError((e) {
        debugPrint("❌ Error updating pet media: $e");
      });
    } catch (e,s) {
      debugPrint("error: $e | stacktrace: $s");
    }
  }  



  Future<Map<String, dynamic>?> getUserData(
    String uid,
  ) async {
    late Map<String, dynamic>? res = {};
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final docSnap = await docRef.get();
      final Map<String, dynamic>? docData = docSnap.data();
      res = docData;
    } catch (e) {
      print("error in getUserData: ${e.toString()}");
    }
    return res;
  }


  Future<void> saveUserToDatabase(Map<String,dynamic> userData) async {
    late String os = "";
    if (Platform.isAndroid) {
      os = 'android';
    } else {
      os = 'iOS';
    }

    final String uid = userData["uid"];
    final String email = userData["email"];
    final String providerData = userData["providerData"];

    final Map<String,dynamic> userDocument = {
      "uid": uid,
      "firstName": "",
      "lastName": "",
      "email": email,
      "phoneNumber": "",
      "parameters" : {
        "theme": 'blue',
      },
      "pets": [],
      "createdAt": DateTime.now().toIso8601String(),
      "providerData": providerData,   
    };
    await _firestore.collection("users").doc(uid).set(userDocument);
  }

  Future<void> updateUserDoc(SettingsController settings, String field, dynamic updatedValue) async {
    try {
      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      final docRef = FirebaseFirestore.instance.collection('users').doc(userData["uid"]);
      await docRef.update({field: updatedValue});
    } catch (e) {
      debugPrint("caught an error running 'updateParameters()' ${e.toString()}");
    }
  }

  Future<void> updatePetDisplayUrl(SettingsController settings, String petId, String updatedValue) async {
    try {
      List<dynamic> petData = settings.petData.value;
      Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId, orElse: ()=><String,dynamic>{});
      petObject.update("displayUrl", (v) => updatedValue);
      settings.setPetData(petData);
      final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);
      await docRef.update({"displayUrl": updatedValue});
    } catch (e) {
      debugPrint("caught an error running 'updateParameters()' ${e.toString()}");
    }
  }

  Future<void> updatePetQuestionnaire(SettingsController settings, String petId, List<dynamic> updatedValue) async {
    try {
      List<dynamic> petData = settings.petData.value;
      Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId, orElse: ()=><String,dynamic>{});
      petObject.update("questionnaire", (v) => updatedValue);
      settings.setPetData(petData);
      final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);
      await docRef.update({"questionnaire": updatedValue});
    } catch (e) {
      debugPrint("caught an error running 'updatePetQuestionnaire()' ${e.toString()}");
    }
  }


  Future<List<Map<String,dynamic>>> fetchPetLocations() async {
    final snapshot = await FirebaseFirestore.instance.collection('pets').get();
    
    return snapshot.docs.map((doc) {
      final geo = doc['location'] as GeoPoint;
      return {
        "id": doc.id,
        "name": doc['name'] ?? '',
        "latitude": geo.latitude,
        "longitude": geo.longitude,
      };
    }).toList();
  }


  Future<List<String>> fetchImageUrls(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null || data['imageUrls'] == null) return [];
    return List<String>.from(data['imageUrls']);
  }    





}