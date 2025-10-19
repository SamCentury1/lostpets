import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  late bool _isEditView = false;
  bool get isEditView => _isEditView;
  void setIsEditView(bool value) {
    _isEditView = value;
    notifyListeners();
  }   
 
}