import 'package:flutter/material.dart';

class BankSelectionViewModel extends ChangeNotifier {
  final List<String> allBanks = [
    "AlexBank",
    "Arab African International Bank",
    "Arab Bank",
    "Arab Banking Corporation Egypt",
    "Arab International Bank",
    "Attijariwafa Bank Egypt",
    "Abu Dhabi Commercial Bank Egypt",
    "Abu Dhabi Islamic Bank - Egypt",
    "Agricultural Bank of Egypt",
    "Al Ahli Bank of Kuwait Egypt",
    "AlBaraka Bank Egypt",
  ];

  List<String> filteredBanks = [];

  BankSelectionViewModel() {
    filteredBanks = allBanks;
  }

  void search(String query) {
    filteredBanks = allBanks
        .where((bank) =>
            bank.toLowerCase().contains(query.toLowerCase()))
        .toList();

    notifyListeners();
  }
}