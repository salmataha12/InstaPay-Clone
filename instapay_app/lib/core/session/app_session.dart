import 'package:flutter/material.dart';

class AppSession extends ChangeNotifier {
  String phoneNumber = "";
  String selectedBank = "";

  void setPhone(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  void setBank(String bank) {
    selectedBank = bank;
    notifyListeners();
  }

  void clear() {
    phoneNumber = "";
    selectedBank = "";
    notifyListeners();
  }
}