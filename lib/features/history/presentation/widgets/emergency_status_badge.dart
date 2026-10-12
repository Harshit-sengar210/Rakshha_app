import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../../models/emergency_history_item.dart';

class EmergencyStatusBadge extends StatelessWidget {
  final EmergencyHistoryStatus status;
  final bool showIcon;
  final double fontSize;
  final EdgeInsets padding;

  const EmergencyStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData? iconData;
    String text;

    switch (status) {
      case EmergencyHistoryStatus.resolved:
        backgroundColor = AppColors.softGreen.withAlpha(40);
        textColor = AppColors.softGreen;
        iconData = Icons.check_circle_outline;
        text = "Resolved";
        break;
      case EmergencyHistoryStatus.cancelled:
        backgroundColor = AppColors.border.withAlpha(100);
        textColor = AppColors.textSecondary;
        iconData = Icons.cancel_outlined;
        text = "Cancelled";
        break;
      case EmergencyHistoryStatus.failed:
        backgroundColor = AppColors.softBlush;
        textColor = AppColors.emergencyRed;
        iconData = Icons.warning_amber_rounded;
        text = "Failed";
        break;
      case EmergencyHistoryStatus.active:
        backgroundColor = AppColors.softBlush;
        textColor = AppColors.emergencyRed;
        iconData = Icons.radio_button_checked;
        text = "Active";
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(iconData, color: textColor, size: fontSize * 1.2),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
