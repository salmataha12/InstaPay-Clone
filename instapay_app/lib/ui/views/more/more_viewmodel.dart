import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/session/app_session.dart';
class MoreItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MoreItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class MoreViewModel {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  List<MoreItem> getItems(BuildContext context) {
    return [
      MoreItem(
        title: "Home",
        icon: Icons.home_outlined,
        onTap: () => context.go('/home'),
      ),
      MoreItem(
        title: "Services",
        icon: Icons.grid_view_rounded,
        onTap: () {},
      ),
      MoreItem(
        title: "Pending Requests",
        icon: Icons.list_alt_outlined,
        onTap: () {},
      ),
      MoreItem(
        title: "Manage Favorites",
        icon: Icons.star_border,
        onTap: () {},
      ),
      MoreItem(
        title: "Transactions",
        icon: Icons.receipt_long_outlined,
        onTap: () => context.go('/bills'), // FIXED
      ),
      MoreItem(
        title: "Blocked IPA",
        icon: Icons.block_outlined,
        onTap: () {},
      ),
      MoreItem(
        title: "Settings",
        icon: Icons.settings_outlined,
        onTap: () {},
      ),
      MoreItem(
        title: "FAQ",
        icon: Icons.help_outline,
        onTap: () {},
      ),
      MoreItem(
        title: "Help",
        icon: Icons.support_agent_outlined,
        onTap: () {},
      ),

      /// 🔒 SECURE LOGOUT
      MoreItem(
        title: "Logout",
        icon: Icons.logout,
        onTap: () => _secureLogout(context),
      ),
    ];
  }

  /// 🔒 FULL SECURE LOGOUT (FRONTEND SECURITY IMPLEMENTATION)
  Future<void> _secureLogout(BuildContext context) async {
    try {
      /// 1. Clear session fully (JWT, tokens, sensitive data in-memory)
      final session = Provider.of<AppSession>(context, listen: false);
      await session.logout();

      /// 2. Navigate out safely
      context.go('/signup');

    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
}