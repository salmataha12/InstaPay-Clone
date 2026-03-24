import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared header that EXACTLY matches the SendView header style:
/// - Purple gradient background with bottom rounded corners
/// - Large orange circle top-RIGHT (partially off-screen)
/// - Smaller orange circle top-RIGHT (inset)
/// - Centered title
/// - White circular back button (top-left)
class CurvedHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const CurvedHeader({super.key, required this.title, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Stack(
        children: [
          // Purple gradient — identical to SendView
          Container(
            width: double.infinity,
            height: 130,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7B2FF7),
                  Color(0xFF9B59F5),
                  Color(0xFFB06EF8),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
          ),

          // Large orange circle — top-RIGHT (same as SendView)
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.75),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Smaller orange circle — also right (same as SendView)
          Positioned(
            top: -10,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Title — centered
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),

          // Back button — top-left (optional)
          if (showBackButton)
            Positioned(
              top: 52,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  if (GoRouter.of(context).canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
