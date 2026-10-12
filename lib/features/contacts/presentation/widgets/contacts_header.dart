import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';

class ContactsHeader extends StatefulWidget {
  const ContactsHeader({super.key});

  @override
  State<ContactsHeader> createState() => _ContactsHeaderState();
}

class _ContactsHeaderState extends State<ContactsHeader> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        bottom: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeTransition(
            opacity: _entranceController,
            child: IconButton(
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceSubtle,
                child: Icon(Icons.person_outline, color: AppColors.deepNavy, size: 20),
              ),
              onPressed: () {},
            ),
          ),
          FadeTransition(
            opacity: _entranceController,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.rakshaaCoral.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: AppColors.rakshaaCoral,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Rakshaa",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.deepNavy,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppColors.deepNavy),
                  onPressed: () {},
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.rakshaaCoral,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
