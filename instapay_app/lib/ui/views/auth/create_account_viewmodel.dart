import 'package:flutter/material.dart';

class CreateAccountViewModel extends ChangeNotifier {
  String name = "";
  bool isChecked = false;
  bool isLoading = false;

  void updateName(String value) {
    name = value.trim();
  }

  void toggleCheck(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  bool validate() {
    return name.isNotEmpty && isChecked;
  }

  Future<bool> register() async {
    if (!validate()) return false;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    return true;
  }
}