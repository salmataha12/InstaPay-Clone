import 'package:flutter/material.dart';
import '../../../core/services/secure_storage_service.dart';

class CreateAccountViewModel extends ChangeNotifier {
  String name = "";
  String pin = "";
  bool isChecked = false;
  bool isLoading = false;

  void updateName(String value) {
    // Sanitize input
    name = value.trim().replaceAll(RegExp(r'[<>]'), '');
  }

  void updatePin(String value) {
    pin = value.replaceAll(RegExp(r'[^\d]'), '');
  }

  void toggleCheck(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  bool validate() {
    return name.isNotEmpty && isChecked && pin.length == 6;
  }

  Future<bool> register() async {
    if (!validate()) return false;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    await SecureStorageService.savePin(pin);
    await SecureStorageService.saveToken("mock_jwt_token_12345");

    isLoading = false;
    notifyListeners();

    return true;
  }
}