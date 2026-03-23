import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {

  /// USER DATA (mock now → backend later)
  String userName = "Hanan Elsayed";
  String account = "hanan_elsayed2710@instapay";
  String accountType = "SAVING XXXXX180";

  /// GREETING BASED ON TIME
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  /// SERVICES
  final List<Map<String, dynamic>> services = [
    {"title": "Send Money", "icon": Icons.send},
    {"title": "Collect Money", "icon": Icons.download},
    {"title": "Bill Payment", "icon": Icons.receipt},
    {"title": "Donations", "icon": Icons.volunteer_activism},
    {"title": "Manage Accounts", "icon": Icons.account_balance},
    {"title": "Transactions History", "icon": Icons.history},
  ];

  /// TRANSACTIONS (mock)
  final List<Map<String, dynamic>> transactions = [
    {
      "amount": "580 EGP",
      "name": "mernatah178@instapay",
      "type": "Received Money",
      "status": "Successful"
    },
    {
      "amount": "70 EGP",
      "name": "01028973355",
      "type": "Send Money",
      "status": "Successful"
    },
    {
      "amount": "262 EGP",
      "name": "Electricity Bill",
      "type": "Bill Payment",
      "status": "Successful"
    },
  ];
}