import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  late bool _isEditView = false;
  bool get isEditView => _isEditView;
  void setIsEditView(bool value) {
    _isEditView = value;
    notifyListeners();
  }


  late Map<String,dynamic> _newPetObject = {
    "uid":"",
    "allowedOutside" : false,
    "birthYear": 2015,
    "breedData": [],
    "diseases": [],
    "displayUrl": "",
    "guardians": [],
    "isLost": false,
    "location": null,
    "media": [],
    "name": "",
    "questionnaire": [],
    "sex": "male",
    "species": "cat",
    "vaccines": [],

  };
  Map<String,dynamic> get newPetObject => _newPetObject;
  void setNewPetObject(Map<String,dynamic> value) {
    _newPetObject = value;
    notifyListeners();
  }


  late Map<String,dynamic> _newPostingData = {
    "petId":"",
    "name": "",
    "displayUrl": "",
    "description": "",
    "missingSince": null,
    "createdAt": null,
    "location": null,
    "reward":null,
  };
  Map<String,dynamic> get newPostingData => _newPostingData;
  void setNewPostingData(Map<String,dynamic> value) {
    _newPostingData = value;
    notifyListeners();
  }  
}