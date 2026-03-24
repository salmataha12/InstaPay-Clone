import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {

  /// USER DATA (mock now → backend later)
  String userName = "Salma Taha";
  String account = "salmataha12@instapay";
  String accountType = "SAVING XXXXX242";

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
      "amount": "50 EGP",
      "name": "mernataha178@instapay",
      "maskedName":"MERNA TAHA",
      "type": "Received Money",
      "date": "19 Mar 2026 03:34 AM",
      "status": "Successful"
    },
    {
      "amount": "650 EGP",
      "name": "Rana Amr",
      "maskedName": "Rana Amr",
      "type": "Send Money",
      "date": "19 Mar 2026 03:19 AM",
      "status": "Successful"
    },
    {
      "amount": "225 EGP",
      "name": "Nada ashraf ",
      "maskedName": "Nada ashraf ",
      "type": "Send Money",
      "date": "19 Mar 2026 03:14 AM",
      "status": "Successful"
    },
  ];
}