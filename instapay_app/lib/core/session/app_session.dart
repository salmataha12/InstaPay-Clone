import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class AppSession extends ChangeNotifier {
  String phoneNumber = "";
  String selectedBank = "";
  bool isAuthenticated = false;
  
  final List<Map<String, String>> _savedBills = [];
  List<Map<String, String>> get savedBills => _savedBills;

  Future<void> initializeSession() async {
    final token = await SecureStorageService.getToken();
    if (token != null && token.isNotEmpty) {
      isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> login(String token) async {
    await SecureStorageService.saveToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await SecureStorageService.clearAll();
    phoneNumber = "";
    selectedBank = "";
    isAuthenticated = false;
    notifyListeners();
  }

  void setPhone(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  void setBank(String bank) {
    selectedBank = bank;
    notifyListeners();
  }

  void clearTempData() {
    phoneNumber = "";
    selectedBank = "";
    notifyListeners();
  }

  void addBill(String name, String number, String provider, String type) {
    _savedBills.add({
      'name': name,
      'number': number,
      'provider': provider,
      'type': type,
    });
    notifyListeners();
  }
}