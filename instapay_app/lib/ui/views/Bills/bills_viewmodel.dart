import 'package:flutter/material.dart';

class BillCategory {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  BillCategory({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class BillsViewModel {

  /// These will later come from backend
  bool hasRecentTransactions = false;
  bool hasBills = false;

  List<BillCategory> getCategories(BuildContext context) {
    return [
      BillCategory(
        title: "Telecom & Internet Bills",
        icon: Icons.phone_in_talk_outlined,
        onTap: () {},
      ),
      BillCategory(
        title: "Telecom & Internet Recharge",
        icon: Icons.phone_android_outlined,
        onTap: () {},
      ),
      BillCategory(
        title: "Electricity Bills",
        icon: Icons.lightbulb_outline,
        onTap: () {},
      ),
      BillCategory(
        title: "Water Bills",
        icon: Icons.water_drop_outlined,
        onTap: () {},
      ),
      BillCategory(
        title: "Gas Bills",
        icon: Icons.local_fire_department_outlined,
        onTap: () {},
      ),
      BillCategory(
        title: "Consumer Finance",
        icon: Icons.account_balance_outlined,
        onTap: () {},
      ),
      BillCategory(
        title: "MicroFinance",
        icon: Icons.description_outlined,
        onTap: () {},
      ),
    ];
  }

  /// Snackbars logic
  void onRecentPressed(BuildContext context) {
    if (!hasRecentTransactions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No transactions found"),
        ),
      );
    }
  }

  void onMyBillsPressed(BuildContext context) {
    if (!hasBills) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No bills added yet"),
        ),
      );
    }
  }
}