import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../models/emergency_history_item.dart';

class LocationTimelineWidget extends StatelessWidget {
  final EmergencyHistoryItem item;

  const LocationTimelineWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item.locationTimeline.isEmpty) return const SizedBox.shrink();

    final timeFormat = DateFormat('h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location Timeline",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.deepNavy,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.rakshaaCoral.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(Icons.location_on, color: AppColors.rakshaaCoral, size: 32),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ...item.locationTimeline.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                final isLast = index == item.locationTimeline.length - 1;
                final isFirst = index == 0;
                final isCancelled = item.status == EmergencyHistoryStatus.cancelled;
                
                Color dotColor = AppColors.rakshaaCoral;
                IconData? icon;
                if (isLast && !isCancelled) {
                  dotColor = AppColors.softGreen;
                  icon = Icons.check;
                } else if (isLast && isCancelled) {
                  dotColor = AppColors.textSecondary;
                  icon = Icons.cancel;
                }

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                              child: icon != null
                                  ? Icon(icon, size: 8, color: Colors.white)
                                  : null,
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: AppColors.border,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timeFormat.format(point.time),
                                style: TextStyle(
                                  color: isFirst || isLast ? AppColors.deepNavy : AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                point.description,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Location sharing ended",
                      style: TextStyle(
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Your live location is no longer being shared because this emergency has ended.",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
