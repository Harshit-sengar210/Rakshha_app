import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import 'package:rakshaa/core/widgets/rakshaa_card.dart';
import '../../providers/home_provider.dart';

class SafetyStatusCard extends ConsumerStatefulWidget {
  const SafetyStatusCard({super.key});

  @override
  ConsumerState<SafetyStatusCard> createState() => _SafetyStatusCardState();
}

class _SafetyStatusCardState extends ConsumerState<SafetyStatusCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showStatusDetails(BuildContext context, HomeState state) {
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
                "Your Safety Status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 24),
              _buildStatusRow(Icons.check_circle, "Rakshaa is ready", AppColors.softGreen),
              const SizedBox(height: 16),
              _buildStatusRow(Icons.security, "Emergency mode\nNot active", AppColors.textSecondary),
              const SizedBox(height: 16),
              _buildStatusRow(Icons.location_on, "Location sharing\nNot active", AppColors.textSecondary),
              const SizedBox(height: 16),
              _buildStatusRow(Icons.people, "Trusted contacts\nReady", AppColors.softGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            color: color == AppColors.textSecondary ? AppColors.textSecondary : AppColors.deepNavy,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final isActivating = state.emergencyState == EmergencyState.activating;
    
    return RakshaaCard(
      onTap: () => _showStatusDetails(context, state),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: isActivating ? 1.0 : _pulseAnimation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActivating ? AppColors.rakshaaCoral : AppColors.softGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Text(
            isActivating ? "Activating Emergency..." : "Safety Status: Ready",
            style: TextStyle(
              color: isActivating ? AppColors.rakshaaCoral : AppColors.deepNavy,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            color: isActivating ? AppColors.rakshaaCoral : AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
