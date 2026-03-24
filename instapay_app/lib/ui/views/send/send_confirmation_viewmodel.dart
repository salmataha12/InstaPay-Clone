import 'package:flutter/material.dart';

class SendConfirmationViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> confirmTransfer() async {
    isLoading = true;
    notifyListeners();

    // Mock network request securely
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    return true;
  }
}
