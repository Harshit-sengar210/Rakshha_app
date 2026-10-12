import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';

enum LoginMethod { phone, email }

class LoginMethodSelector extends StatelessWidget {
  final LoginMethod selectedMethod;
  final ValueChanged<LoginMethod> onMethodChanged;

  const LoginMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: "Phone",
              icon: Icons.phone_outlined,
              isSelected: selectedMethod == LoginMethod.phone,
              onTap: () => onMethodChanged(LoginMethod.phone),
            ),
          ),
          Expanded(
            child: _TabButton(
              title: "Email",
              icon: Icons.email_outlined,
              isSelected: selectedMethod == LoginMethod.email,
              onTap: () => onMethodChanged(LoginMethod.email),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.rakshaaCoral.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.rakshaaCoral.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.rakshaaCoral : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.deepNavy : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
