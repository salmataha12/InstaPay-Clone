import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  int selectedSim = 1;
  bool isLoading = false;

  String phoneNumber = "";

  /// Select SIM
  void selectSim(int sim) {
    selectedSim = sim;
    notifyListeners();
  }

  /// Update phone number
  void updatePhone(String value) {
    phoneNumber = value.trim();
  }

  /// Egyptian number validation
  bool isValidEgyptianNumber() {
    final regex = RegExp(r'^1[0125][0-9]{8}$');
    return regex.hasMatch(phoneNumber);
  }

  /// Validate all inputs
  bool validate() {
    return selectedSim != 0 && isValidEgyptianNumber();
  }

  /// Simulate secure OTP request
  Future<bool> sendOTP() async {
    if (!validate()) return false;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    return true;
  }
}