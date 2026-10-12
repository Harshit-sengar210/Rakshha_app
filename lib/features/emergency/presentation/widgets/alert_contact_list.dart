import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../models/emergency_contact.dart';
import '../../providers/emergency_provider.dart';

class AlertContactList extends ConsumerWidget {
  const AlertContactList({super.key});

  void _showDetails(BuildContext context, List<EmergencyAlertContact> contacts) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Emergency Alert Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 24),
              ...contacts.map((c) => _buildDetailRow(c)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(EmergencyAlertContact contact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.deepNavy,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                contact.status == AlertStatus.sent ? Icons.check : Icons.hourglass_empty,
                color: contact.status == AlertStatus.sent ? AppColors.softGreen : AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Alert ${contact.status == AlertStatus.sent ? 'sent' : 'sending'}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                contact.status == AlertStatus.sent ? Icons.check : Icons.hourglass_empty,
                color: contact.status == AlertStatus.sent ? AppColors.softGreen : AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Location ${contact.status == AlertStatus.sent ? 'shared' : 'sharing'}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(emergencyProvider).contacts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Alerts Sent To",
              style: const TextStyle(
                color: AppColors.deepNavy,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () => _showDetails(context, contacts),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.rakshaaCoral,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "View Details",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...contacts.asMap().entries.map((entry) {
          return _AnimatedContactRow(
            contact: entry.value,
            index: entry.key,
          );
        }),
      ],
    );
  }
}

class _AnimatedContactRow extends StatefulWidget {
  final EmergencyAlertContact contact;
  final int index;

  const _AnimatedContactRow({
    required this.contact,
    required this.index,
  });

  @override
  State<_AnimatedContactRow> createState() => _AnimatedContactRowState();
}

class _AnimatedContactRowState extends State<_AnimatedContactRow> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _statusController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _statusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(Duration(milliseconds: 800 + (widget.index * 200)), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant _AnimatedContactRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contact.status != widget.contact.status && widget.contact.status == AlertStatus.sent) {
      _statusController.forward();
    } else if (widget.contact.status == AlertStatus.sent && _statusController.status != AnimationStatus.completed) {
      _statusController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.person, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.contact.name,
                          style: const TextStyle(
                            color: AppColors.deepNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.contact.label,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.contact.message,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (widget.contact.status == AlertStatus.sending) {
      return const Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: 6),
          Text(
            "Sending",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          ScaleTransition(
            scale: CurvedAnimation(parent: _statusController, curve: Curves.easeOutBack),
            child: FadeTransition(
              opacity: _statusController,
              child: const Icon(Icons.check, color: AppColors.softGreen, size: 16),
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            "Just now",
            style: TextStyle(
              color: AppColors.softGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }
}
