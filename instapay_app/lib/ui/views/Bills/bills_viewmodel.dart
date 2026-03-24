import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class BillsViewModel extends ChangeNotifier {
  int selectedTab = 0; // 0 = Recent/Categories, 1 = My Bills

  void setTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  List<BillCategory> getCategories(BuildContext context) {
    return [
      BillCategory(
        title: "Telecom & Internet Bills",
        icon: Icons.phone_in_talk_outlined,
        onTap: () {
          context.push('/telecom_bills');
        },
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
}