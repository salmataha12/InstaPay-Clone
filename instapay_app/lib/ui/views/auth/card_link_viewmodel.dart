import 'package:flutter/material.dart';


class CardLinkViewModel extends ChangeNotifier {
  String cardNumber = "";
  String pin = "";
  bool isLoading = false;

  void addCardDigit(String digit) {
    if (cardNumber.length < 16) {
      cardNumber += digit;
      notifyListeners();
    }
  }

  void removeCardDigit() {
    if (cardNumber.isNotEmpty) {
      cardNumber = cardNumber.substring(0, cardNumber.length - 1);
      notifyListeners();
    }
  }

  void addPinDigit(String digit) {
    if (pin.length < 4) {
      pin += digit;
      notifyListeners();
    }
  }

  void removePinDigit() {
    if (pin.isNotEmpty) {
      pin = pin.substring(0, pin.length - 1);
      notifyListeners();
    }
  }

  /// Luhn Algorithm
  bool isValidCard() {
    if (cardNumber.length != 16) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cardNumber[i]);

      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }

      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  bool isValidPin() {
    return pin.length == 4;
  }

  bool validate() {
    return isValidCard() && isValidPin();
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    return true;
  }

  bool isPinVisible = false;

void togglePinVisibility() {
  isPinVisible = !isPinVisible;
  notifyListeners();
}
}
