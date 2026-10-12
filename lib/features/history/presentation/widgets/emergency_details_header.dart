import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../models/emergency_history_item.dart';

class EmergencyDetailsHeader extends StatelessWidget {
  final EmergencyHistoryItem item;

  const EmergencyDetailsHeader({
    super.key,
    required this.item,
  });

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return "${duration.inMinutes} min ${duration.inSeconds.remainder(60)} sec";
    }
    return "${duration.inSeconds} sec";
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('h:mm a');

    Color backgroundColor;
    Color textColor;
    IconData iconData;
    String statusText;

    switch (item.status) {
      case EmergencyHistoryStatus.resolved:
        backgroundColor = AppColors.softGreen.withAlpha(20);
        textColor = AppColors.softGreen;
        iconData = Icons.check;
        statusText = "Emergency Resolved";
        break;
      case EmergencyHistoryStatus.cancelled:
        backgroundColor = AppColors.border.withAlpha(50);
        textColor = AppColors.textSecondary;
        iconData = Icons.cancel_outlined;
        statusText = "Emergency Cancelled";
        break;
      case EmergencyHistoryStatus.failed:
        backgroundColor = AppColors.softBlush;
        textColor = AppColors.emergencyRed;
        iconData = Icons.warning_amber_rounded;
        statusText = "Emergency Failed";
        break;
      case EmergencyHistoryStatus.active:
        backgroundColor = AppColors.softBlush;
        textColor = AppColors.emergencyRed;
        iconData = Icons.radio_button_checked;
        statusText = "Emergency Active";
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: textColor, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor == AppColors.textSecondary ? AppColors.deepNavy : textColor,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "${dateFormat.format(item.startedAt)} · ${timeFormat.format(item.startedAt)}",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Duration · ${_formatDuration(item.duration)}",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
