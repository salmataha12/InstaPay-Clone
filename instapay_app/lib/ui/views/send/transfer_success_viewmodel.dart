import 'package:flutter/material.dart';

class TransferSuccessViewModel extends ChangeNotifier {
  bool isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
