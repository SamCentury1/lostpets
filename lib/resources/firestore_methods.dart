import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tempoct2025/functions/helpers.dart';
import 'package:tempoct2025/providers/app_state.dart';
import 'package:tempoct2025/settings/settings.dart';

class FirestoreMethods {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<Map<String,dynamic>> getFirestoreDocument(String uid) async {
    late DocumentSnapshot<Map<String,dynamic>> docStream;
    docStream = await _firestore.collection("users").doc(uid).get();
    return docStream.data() as Map<String, dynamic>;
  } 

  Future<List<Map<String,dynamic>>> retrieveRequestDocuments(String userId) async {

    List<Map<String, dynamic>> results = [];
    try {

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('requests')
          .where('targetId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        results.add(doc.data());
      }
    } catch (e,s) {
      debugPrint("error at retrieveRequestDocuments: $e | stacktrace: $s");
    }
    return results;   
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

  Future<List<Map<String,dynamic>>> retrieveSelectPetDocuments(List<dynamic> petIds) async {
    if (petIds.isEmpty) return [];

    try {
      // Firestore whereIn allows max 10 items
      const int batchSize = 10;
      List<Map<String, dynamic>> results = [];

      for (int i = 0; i < petIds.length; i += batchSize) {
        final List<dynamic> batch = petIds.sublist(
          i,
          i + batchSize > petIds.length ? petIds.length : i + batchSize,
        );

        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('pets')
            .where('uid', whereIn: batch)
            .get();

        for (var doc in snapshot.docs) {
          results.add(doc.data());
        }
      }

      return results;
    } catch (e,s) {
      debugPrint("error retrieveSelectPetDocuments : $e | s: $s");
      return [];
    }
  }

  Future<void> updateRequestDocument(SettingsController settings, String requestId, String field, dynamic value) async {
    final docRef = FirebaseFirestore.instance.collection('requests').doc(requestId);
    List<dynamic> requests = settings.requestsData.value;
    Map<String,dynamic> requestDoc = requests.firstWhere((e)=>e["uid"]==requestId,orElse: ()=><String,dynamic>{});
    if (requestDoc.isNotEmpty) {
      requestDoc.update(field, (v)=>value);
    }
    settings.setRequestsData(requests);
    try {
      await docRef.update({field: value});
    } catch (e,s) {
      debugPrint("error in updateRequestDocument: $e | stacktrace: $s");
    }

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

  Future<void> updatePetLocation(String petId, GeoPoint newLocation) async {
    final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);
    try {
      await docRef.update({'location': newLocation});
    } catch (e,s) {
      debugPrint("error updating location: $e | stacktrace: $s");
    }

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



  Future<Map<String, dynamic>?> getUserData(String uid,) async {
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


  Future<void> createPetObjectInDatabase(SettingsController settings, AppState appState, File? petImage) async {
    try {
      // final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);

      Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      List<dynamic> petData = settings.petData.value;
      final userDoc = _firestore.collection("users").doc(userData["uid"]);
      List<dynamic> userPets = userData["pets"];

      final petsRef = _firestore.collection("pets");
      final docRef = petsRef.doc();
      final String uid = docRef.id;



      if (petImage!=null) {

        final ref = _storage
            .ref()
            .child('user_uploads/$uid/${DateTime.now().millisecondsSinceEpoch}');

        final uploadTask = ref.putFile(petImage);

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();


        if (downloadUrl != "") {
          appState.newPetObject.update("media", (v) => [downloadUrl]);
          appState.newPetObject.update("displayUrl", (v)=> downloadUrl);
        }
      }

      appState.newPetObject.update("uid", (v)=>uid);
      appState.newPetObject.update("guardians", (v)=>[userData["uid"]]);
      userPets.add(uid);
      petData.add(appState.newPetObject);


      await docRef.set(appState.newPetObject);
      await userDoc.update({"pets": userPets});

      settings.setUserData(settings.userData.value);
      settings.setPetData(settings.petData.value);



      appState.newPetObject.forEach((k,v) {
        print("key: $k | value: $v");
      });
      print("in updatePetObjectInDatabase: ${appState.newPetObject}");
      // docRef.update({"data"})
      
    } catch (e,s) {
      debugPrint("error updating pet object: $e | stacktrace: $s");
    }
  }

  Future<String?> validateTargetEmail(String email) async {
    late String? res;
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // res = true;
      res = snapshot.docs.first.id;
    }
    return res;
  }

  Future<void> createRequestDocument(Map<String,dynamic> requestObj) async {

    final docRef = _firestore.collection('requests').doc();

    final Map<String,dynamic> userDocument = {
      "uid": docRef.id,
      "createdAt": DateTime.now().toIso8601String(),
      "message": requestObj["message"],
      "pets": requestObj["pets"],
      "sourceId": requestObj["sourceId"],
      "targetId": requestObj["targetId"],
      "type": requestObj["type"],
      "status":"pending",
      "viewed":false,
    };
    await docRef.set(userDocument);    
  }


  Future<void> updatePetObjectInDatabase(SettingsController settings, String petId, AppState appState) async {
    try {

      // Map<String,dynamic> userData = settings.userData.value as Map<String,dynamic>;
      List<dynamic> petData = settings.petData.value;
      Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId,orElse: ()=><String,dynamic>{});

      petObject = appState.newPetObject;
      settings.setPetData(petData);

      final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);

      // appState.newPetObject.forEach((k,v) {
      //   print("key: $k | value: $v");
      // });
      // print("in updatePetObjectInDatabase: ${appState.newPetObject}");
      docRef.update(appState.newPetObject);


      
    } catch (e,s) {
      debugPrint("error updating pet object: $e | stacktrace: $s");
    }
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
    final String fName = userData["firstName"];
    final String lName = userData["lastName"];

    final Map<String,dynamic> userDocument = {
      "uid": uid,
      "firstName": fName,
      "lastName": lName,
      "email": email,
      "phoneNumber": "",
      "parameters" : {
        "theme": 'light',
      },
      "notifications":[],
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


  Future<void> addGuardianToPet(String userId, String petId) async {
    try {
      // List<dynamic> petData = settings.petData.value;
      // Map<String,dynamic> petObject = petData.firstWhere((e)=>e["uid"]==petId, orElse: ()=><String,dynamic>{});
      // petObject.update("guardians", (v) => updatedValue);
      // settings.setPetData(petData);
      final docRef = FirebaseFirestore.instance.collection('pets').doc(petId);
      final docSnap = await docRef.get();
      Map<String,dynamic>? petObject = docSnap.data();
      List<dynamic> guardians = petObject!["guardians"];
      guardians.add(userId);
      await docRef.update({"guardians": guardians});
    } catch (e) {
      debugPrint("caught an error running 'addGuardianToPet()' ${e.toString()}");
    }
  }


  Future<List<Map<String,dynamic>>> fetchLostPetLocations() async {
    final snapshot = await _firestore.collection('postings').get();
    print("postings: ${snapshot.docs.length}");

    try {
      List<Map<String,dynamic>> res = [];
      for (int i=0; i<snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        if (doc['location'] != null) {
          final geo = doc['location'] as GeoPoint;
          Map<String,dynamic> obj = {
            "postingId": doc.id,
            "uid": doc["petId"],
            "name": doc['name'] ?? '',
            "missingSince": doc["missingSince"],
            "description": doc["description"],
            // "location": {"longitude":geo.longitude,"latitude":geo.latitude},
            "location": LatLng(geo.latitude,geo.longitude),
            "displayUrl": doc["displayUrl"]
            // "latitude": geo.latitude,
            // "longitude": geo.longitude,
          };
          res.add(obj);
        } 
      }
      return res;
      // return snapshot.docs.map((doc) {

      //   Map<String,dynamic> res = {};
      //   if (doc['location'] != null) {
      //     final geo = doc['location'] as GeoPoint;
      //     res = {
      //       "uid": doc.id,
      //       "name": doc['name'] ?? '',
      //       "location": {"longitude":geo.longitude,"latitude":geo.latitude},
      //       "displayUrl": doc["displayUrl"]
      //       // "latitude": geo.latitude,
      //       // "longitude": geo.longitude,
      //     };
      //   } 
      //   return res;

      // }).toList();
    } catch (e,s) {
      debugPrint("error: $e | stacktrace: $s");
      return [];
    }
  }


  Future<List<String>> fetchImageUrls(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null || data['imageUrls'] == null) return [];
    return List<String>.from(data['imageUrls']);
  }


  Future<void> createPosting(AppState appState,) async {
    try {
      final petDocRef = await _firestore.collection("pets").doc(appState.newPostingData["petId"]);
      await petDocRef.update({"isLost": true});
      await _firestore.collection("postings").doc().set(appState.newPostingData);     
    } catch (e,s) {
      debugPrint("error: $e | stacktrace: $s");
    }
  }




}