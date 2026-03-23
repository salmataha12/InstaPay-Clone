import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  int _getIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/send')) return 1;
    if (location.startsWith('/collect')) return 2;
    if (location.startsWith('/bills')) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _getIndex(location);

    return Scaffold(
      body: child,

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _item(context, Icons.home, "Home", 0, currentIndex, '/home'),
            _item(context, Icons.send, "Send", 1, currentIndex, '/send'),
            _item(context, Icons.download, "Collect", 2, currentIndex, '/collect'),
            _item(context, Icons.receipt, "Bills", 3, currentIndex, '/bills'),
            _item(context, Icons.menu, "More", 4, currentIndex, '/more'),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label,
      int index, int currentIndex, String route) {

    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => context.go(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF7B2FF7) : Colors.grey,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF7B2FF7) : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}