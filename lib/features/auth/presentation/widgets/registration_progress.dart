import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';

class RegistrationProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgress({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step $currentStep of $totalSteps",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF71809A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index % 2 == 0) {
              final stepIndex = index ~/ 2 + 1;
              final isCompleted = stepIndex < currentStep;
              final isActive = stepIndex == currentStep;
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.softGreen
                      : isActive
                          ? AppColors.rakshaaCoral
                          : Colors.white,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.softGreen
                        : isActive
                            ? AppColors.rakshaaCoral
                            : const Color(0xFFE9EAF0),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 8, color: Colors.white)
                    : null,
              );
            } else {
              final stepIndex = index ~/ 2 + 1;
              final isLineActive = stepIndex < currentStep;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  color: isLineActive ? AppColors.softGreen : const Color(0xFFE9EAF0),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
