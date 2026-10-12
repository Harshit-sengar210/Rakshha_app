import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../models/emergency_history_item.dart';

class EmergencySummary extends StatelessWidget {
  final EmergencyHistoryItem item;

  const EmergencySummary({
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
    final timeFormat = DateFormat('h:mm a');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Emergency Summary",
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
            children: [
              _buildRow(Icons.play_circle_outline, "Started", timeFormat.format(item.startedAt)),
              const Divider(color: AppColors.border, height: 24),
              _buildRow(
                Icons.stop_circle_outlined, 
                "Ended", 
                item.endedAt != null ? timeFormat.format(item.endedAt!) : "Unknown",
              ),
              const Divider(color: AppColors.border, height: 24),
              _buildRow(Icons.timer_outlined, "Duration", _formatDuration(item.duration)),
              const Divider(color: AppColors.border, height: 24),
              _buildRow(Icons.location_on_outlined, "Location", item.locationName),
              const Divider(color: AppColors.border, height: 24),
              _buildRow(Icons.tag, "Emergency ID", item.id, isMuted: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(IconData icon, String label, String value, {bool isMuted = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: isMuted ? AppColors.textSecondary : AppColors.deepNavy,
                  fontWeight: isMuted ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
