import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../models/emergency_history_item.dart';

class ResolutionCard extends StatelessWidget {
  final EmergencyHistoryItem item;

  const ResolutionCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item.status == EmergencyHistoryStatus.active) {
      return const SizedBox.shrink();
    }

    final timeFormat = DateFormat('h:mm a');
    final timeStr = item.endedAt != null ? timeFormat.format(item.endedAt!) : "";

    Color bgColor;
    Color iconColor;
    IconData icon;
    String title;
    String description;

    switch (item.status) {
      case EmergencyHistoryStatus.resolved:
        bgColor = AppColors.softGreen.withAlpha(20);
        iconColor = AppColors.softGreen;
        icon = Icons.check_circle_outline;
        title = "Emergency resolved";
        description = "You ended Emergency Mode.\n\nLive location sharing stopped.";
        break;
      case EmergencyHistoryStatus.cancelled:
        bgColor = AppColors.border.withAlpha(50);
        iconColor = AppColors.textSecondary;
        icon = Icons.cancel_outlined;
        title = "Emergency cancelled";
        description = "This emergency session was cancelled shortly after activation.";
        break;
      case EmergencyHistoryStatus.failed:
        bgColor = AppColors.softBlush;
        iconColor = AppColors.emergencyRed;
        icon = Icons.warning_amber_rounded;
        title = "Emergency failed";
        description = "Some emergency actions could not be completed.";
        break;
      default:
        return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Emergency Resolution",
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
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: iconColor.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: iconColor == AppColors.textSecondary ? AppColors.deepNavy : iconColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (timeStr.isNotEmpty)
                    Text(
                      timeStr,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  color: iconColor == AppColors.textSecondary ? AppColors.textSecondary : iconColor.withAlpha(200),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
