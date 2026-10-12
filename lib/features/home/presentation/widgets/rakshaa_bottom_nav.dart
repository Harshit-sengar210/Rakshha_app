import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RakshaaBottomNav extends StatelessWidget {
  const RakshaaBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF090A10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF131622),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home (Active)
              _buildNavItem(
                context: context,
                icon: Icons.home_rounded,
                label: "Home",
                isActive: location == '/home' || location == '/',
                onTap: () {
                  if (location != '/home' && location != '/') context.go('/home');
                },
              ),

              // 2. History
              _buildNavItem(
                context: context,
                icon: Icons.history_rounded,
                label: "History",
                isActive: location.startsWith('/history'),
                onTap: () {
                  if (!location.startsWith('/history')) context.go('/history');
                },
              ),

              // 3. Contacts
              _buildNavItem(
                context: context,
                icon: Icons.people_outline_rounded,
                label: "Contacts",
                isActive: location == '/contacts',
                onTap: () {
                  if (location != '/contacts') context.go('/contacts');
                },
              ),

              // 4. Settings
              _buildNavItem(
                context: context,
                icon: Icons.settings_outlined,
                label: "Settings",
                isActive: location == '/profile',
                onTap: () {
                  if (location != '/profile') context.go('/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF2E63).withOpacity(0.25),
                const Color(0xFFFF2E63).withOpacity(0.08),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFF2E63).withOpacity(0.35),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: const Color(0xFFFF2E63),
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFFF2E63),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
