import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../models/emergency_history_item.dart';

class AlertHistoryCard extends StatelessWidget {
  final EmergencyAlertRecord alert;
  final VoidCallback onTap;

  const AlertHistoryCard({
    super.key,
    required this.alert,
    required this.onTap,
  });

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');
    final bool isFailed = alert.status.toLowerCase() == "failed";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: alert.isPriority ? AppColors.softBlush : AppColors.background,
                shape: BoxShape.circle,
                border: alert.isPriority ? Border.all(color: AppColors.rakshaaCoral.withAlpha(50)) : null,
              ),
              child: Center(
                child: Text(
                  _getInitials(alert.name),
                  style: TextStyle(
                    color: alert.isPriority ? AppColors.rakshaaCoral : AppColors.deepNavy,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        alert.name,
                        style: const TextStyle(
                          color: AppColors.deepNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (alert.isPriority) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.softBlush,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Priority",
                            style: TextStyle(
                              color: AppColors.rakshaaCoral,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${alert.relationship} · ${alert.channel}",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      isFailed ? Icons.error_outline : Icons.check,
                      color: isFailed ? AppColors.emergencyRed : AppColors.softGreen,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      alert.status,
                      style: TextStyle(
                        color: isFailed ? AppColors.emergencyRed : AppColors.softGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  timeFormat.format(alert.time),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
