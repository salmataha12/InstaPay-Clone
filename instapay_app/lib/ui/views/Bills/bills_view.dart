import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instapay_app/core/session/app_session.dart';
import 'package:instapay_app/ui/widgets/curved_header.dart';
import 'bills_viewmodel.dart';

class BillsView extends StatelessWidget {
  const BillsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillsViewModel(),
      child: const _BillsBody(),
    );
  }
}

class _BillsBody extends StatelessWidget {
  const _BillsBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BillsViewModel>();
    final session = context.watch<AppSession>();
    final categories = vm.getCategories(context);
    final savedBills = session.savedBills;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            const CurvedHeader(title: "Bill Payment"),
            const SizedBox(height: 18),

            // Top Buttons (Recent / My Bills)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTabButton(
                    context,
                    label: "Recent",
                    icon: Icons.access_time,
                    isSelected: vm.selectedTab == 0,
                    onTap: () => vm.setTab(0),
                  ),
                  const SizedBox(width: 12),
                  _buildTabButton(
                    context,
                    label: "My Bills (${savedBills.length})",
                    icon: Icons.receipt_long,
                    isSelected: vm.selectedTab == 1,
                    onTap: () => vm.setTab(1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // List Content
            Expanded(
              child: vm.selectedTab == 0
                  ? _buildCategoriesList(categories)
                  : _buildSavedBillsList(savedBills),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context,
      {required String label,
      required IconData icon,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE5D6) : const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? Border.all(color: const Color(0xFFFF8C42)) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFF888888)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFF888888),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(List<BillCategory> categories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return _buildItemRow(
          icon: item.icon,
          title: item.title,
          onTap: item.onTap,
        );
      },
    );
  }

  Widget _buildSavedBillsList(List<Map<String, String>> bills) {
    if (bills.isEmpty) {
      return const Center(
        child: Text(
          "No bills added yet",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _buildItemRow(
          icon: Icons.receipt,
          title: bill['name'] ?? 'Bill',
          subtitle: "${bill['provider']} - ${bill['number']}",
          onTap: () {}, // Handle bill click
        );
      },
    );
  }

  Widget _buildItemRow(
      {required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8DF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFFFF7A45), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}