import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';

class RememberForgotRow extends StatefulWidget {
  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPressed;

  const RememberForgotRow({
    super.key,
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPressed,
  });

  @override
  State<RememberForgotRow> createState() => _RememberForgotRowState();
}

class _RememberForgotRowState extends State<RememberForgotRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => widget.onRememberChanged(!widget.rememberMe),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.rememberMe ? AppColors.rakshaaCoral : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: widget.rememberMe ? AppColors.rakshaaCoral : const Color(0xFFE9EAF0),
                    width: 1.5,
                  ),
                ),
                child: widget.rememberMe
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              const Text(
                "Remember me",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF71809A), // mutedBlue
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: widget.onForgotPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "Forgot password?",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.rakshaaCoral,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
