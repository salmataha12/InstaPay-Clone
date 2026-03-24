import 'package:flutter/material.dart';
import '../../../core/services/secure_storage_service.dart';

class PinEntryViewModel extends ChangeNotifier {
  String pin = "";
  bool obscurePin = true;
  bool isLoading = false;
  String? error;

  void addDigit(String d) {
    if (pin.length < 6) {
      pin += d;
      error = null;
      notifyListeners();
    }
  }

  void removeDigit() {
    if (pin.isNotEmpty) {
      pin = pin.substring(0, pin.length - 1);
      error = null;
      notifyListeners();
    }
  }

  void toggleVisibility() {
    obscurePin = !obscurePin;
    notifyListeners();
  }

  Future<bool> verify() async {
    if (pin.length < 6) {
      error = "PIN must be 6 digits";
      notifyListeners();
      return false;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    // Read stored PIN securely
    final savedPin = await SecureStorageService.getPin();
    
    // Simulate API verification delay
    await Future.delayed(const Duration(milliseconds: 1200));
    
    isLoading = false;

    // Verify
    if (savedPin == pin) {
      return true;
    } else {
      error = "Incorrect PIN. Try again.";
      pin = ""; // Reset
      notifyListeners();
      return false;
    }
  }
}
