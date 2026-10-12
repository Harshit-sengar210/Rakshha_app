import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import '../../providers/home_provider.dart';

class SosButton extends ConsumerStatefulWidget {
  const SosButton({super.key});

  @override
  ConsumerState<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends ConsumerState<SosButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _holdController;
  
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: AppDurations.sosPulse,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _holdController = AnimationController(
      vsync: this,
      duration: AppDurations.sosHold,
    );

    _holdController.addListener(() {
      setState(() {});
      if (_holdController.value == 0.5) {
        HapticFeedback.mediumImpact();
      }
    });

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        ref.read(homeProvider.notifier).setEmergencyState(EmergencyState.activating);
        
        // Reset the button immediately before navigation so it looks correct if returning
        _holdController.reset();
        setState(() {
          _isHolding = false;
        });

        // Navigate to emergency screen
        if (mounted) {
          GoRouter.of(context).push('/emergency/active');
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _holdController.dispose();
    super.dispose();
  }

  void _triggerSOS() {
    HapticFeedback.heavyImpact();
    ref.read(homeProvider.notifier).setEmergencyState(EmergencyState.activating);
    
    // Navigate to emergency screen
    if (mounted) {
      GoRouter.of(context).push('/emergency/active');
    }
  }

  String get _sosSubText {
    return "Tap to Get Help";
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Emergency SOS. Tap to activate immediately.",
      button: true,
      child: GestureDetector(
        onTap: _triggerSOS,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softBlush,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rakshaaCoral.withAlpha((( 0.2 * 255 ).toInt())),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isHolding)
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: _holdController.value,
                          strokeWidth: 6,
                          color: AppColors.rakshaaCoral,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.rakshaaCoral,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.rakshaaCoral.withAlpha((( 0.4 * 255 ).toInt())),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "SOS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _sosSubText,
                            style: TextStyle(
                              color: Colors.white.withAlpha((( 0.9 * 255 ).toInt())),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
