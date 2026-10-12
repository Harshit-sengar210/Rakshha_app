import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../providers/history_provider.dart';
import 'widgets/emergency_details_header.dart';
import 'widgets/emergency_summary.dart';
import 'widgets/location_timeline.dart';
import 'widgets/alert_history_card.dart';
import 'widgets/alert_details_sheet.dart';
import 'widgets/resolution_card.dart';

class EmergencyDetailsPage extends ConsumerStatefulWidget {
  final String id;

  const EmergencyDetailsPage({super.key, required this.id});

  @override
  ConsumerState<EmergencyDetailsPage> createState() => _EmergencyDetailsPageState();
}

class _EmergencyDetailsPageState extends ConsumerState<EmergencyDetailsPage> {
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete this emergency record?"),
        content: const Text("This cannot be undone."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: AppColors.deepNavy)),
          ),
          TextButton(
            onPressed: () {
              ref.read(historyProvider.notifier).deleteRecord(widget.id);
              Navigator.pop(context); // close dialog
              context.pop(); // go back to history list
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.emergencyRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);
    final item = state.records.firstWhere(
      (r) => r.id == widget.id,
      orElse: () => state.records.first,
    );

    // If item not found (e.g., after deletion before pop completes), return empty
    if (!state.records.any((r) => r.id == widget.id)) {
      return const Scaffold(backgroundColor: AppColors.background);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepNavy),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Emergency Details",
          style: TextStyle(color: AppColors.deepNavy, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: AppColors.deepNavy),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text("Delete Record", style: TextStyle(color: AppColors.emergencyRed)),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmergencyDetailsHeader(item: item),
            const SizedBox(height: AppSpacing.xl),
            EmergencySummary(item: item),
            const SizedBox(height: AppSpacing.xl),
            LocationTimelineWidget(item: item),
            const SizedBox(height: AppSpacing.xl),
            if (item.alerts.isNotEmpty) ...[
              const Text(
                "Alerts & Messages",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "People Rakshaa attempted to notify during this emergency.",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...item.alerts.map((alert) => AlertHistoryCard(
                alert: alert,
                onTap: () => showAlertDetailsSheet(context, alert),
              )),
              const SizedBox(height: AppSpacing.xl),
            ],
            ResolutionCard(item: item),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
