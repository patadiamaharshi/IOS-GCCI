import 'package:flutter/material.dart';

class ConfirmViewModel extends ChangeNotifier {

  bool isAccept = false;

  void setAccept(bool value) {
    isAccept = value;
    notifyListeners();
  }
}
