import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class AppSession extends ChangeNotifier {
  String phoneNumber = "";
  String selectedBank = "";
  bool isAuthenticated = false;

  final List<Map<String, String>> _savedBills = [];
  List<Map<String, String>> get savedBills => _savedBills;

  final List<Map<String, dynamic>> _transactions = [
    {
      "amount": "50 EGP",
      "name": "mernataha178@instapay",
      "maskedName": "MERNA TAHA",
      "type": "Received Money",
      "date": "19 Mar 2026 03:34 AM",
      "status": "Successful",
    },
    {
      "amount": "650 EGP",
      "name": "Kareem Hifnawy",
      "maskedName": "KAREEM T**** M****** S***",
      "type": "Send Money",
      "date": "19 Mar 2026 03:19 AM",
      "status": "Successful",
    },
    {
      "amount": "225 EGP",
      "name": "MERNA",
      "maskedName": "***ميرنا ط* ع****** ح",
      "type": "Send Money",
      "date": "19 Mar 2026 03:14 AM",
      "status": "Successful",
    },
    {
      "amount": "580 EGP",
      "name": "mernataha178@instapay",
      "maskedName": "MERNA TAHA",
      "type": "Received Money",
      "date": "11 Mar 2026 02:09 PM",
      "status": "Successful",
    },
  ];

  List<Map<String, dynamic>> get transactions => _transactions;

  void addTransaction({
    required String amount,
    required String name,
    required String maskedName,
    required String type,
    required String status,
    required String date,
  }) {
    _transactions.insert(0, {
      'amount': amount,
      'name': name,
      'maskedName': maskedName,
      'type': type,
      'date': date,
      'status': status,
    });
    notifyListeners();
  }

  DateTime? tokenExpiry;

  Future<void> initializeSession() async {
    final token = await SecureStorageService.getToken();
    final expiry = await SecureStorageService.getTokenExpiry();

    if (token != null &&
        token.isNotEmpty &&
        expiry != null &&
        DateTime.now().isBefore(expiry)) {
      isAuthenticated = true;
      tokenExpiry = expiry;
      notifyListeners();
      return;
    }

    await logout();
  }

  Future<void> login(
    String token, {
    Duration validFor = const Duration(minutes: 30),
  }) async {
    final expiryDate = DateTime.now().add(validFor);
    await SecureStorageService.saveToken(token);
    await SecureStorageService.saveTokenExpiry(expiryDate);
    isAuthenticated = true;
    tokenExpiry = expiryDate;
    notifyListeners();
  }

  Future<void> rotateToken(
    String newToken, {
    Duration validFor = const Duration(minutes: 30),
  }) async {
    await login(newToken, validFor: validFor);
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
