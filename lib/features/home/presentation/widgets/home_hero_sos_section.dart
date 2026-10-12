import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';

class HomeHeroSosSection extends ConsumerStatefulWidget {
  final VoidCallback? onShareLiveLocation;
  final VoidCallback? onSendToWhatsApp;
  final VoidCallback? onTriggerEmergency;

  const HomeHeroSosSection({
    super.key,
    this.onShareLiveLocation,
    this.onSendToWhatsApp,
    this.onTriggerEmergency,
  });

  @override
  ConsumerState<HomeHeroSosSection> createState() => _HomeHeroSosSectionState();
}

class _HomeHeroSosSectionState extends ConsumerState<HomeHeroSosSection> with SingleTickerProviderStateMixin {
  late AnimationController _tapAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.92,
      upperBound: 1.0,
    )..value = 1.0;

    _scaleAnimation = _tapAnimationController;
  }

  @override
  void dispose() {
    _tapAnimationController.dispose();
    super.dispose();
  }

  void _triggerEmergency() async {
    HapticFeedback.heavyImpact();
    
    // Quick micro-tap scale feedback
    await _tapAnimationController.reverse();
    await _tapAnimationController.forward();

    ref.read(homeProvider.notifier).setEmergencyState(EmergencyState.activating);

    if (widget.onTriggerEmergency != null) {
      widget.onTriggerEmergency!();
    } else if (mounted) {
      context.push('/emergency/active');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Button: Share Live Location
        _buildSideActionButton(
          icon: Icons.location_on_outlined,
          label: "Share\nLive Location",
          onTap: widget.onShareLiveLocation ?? () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF131622),
                content: Text("Live location tracking is actively broadcasting."),
              ),
            );
          },
        ),

        // Center Hero: Instant Single-Tap SOS Button
        GestureDetector(
          onTap: _triggerEmergency,
          behavior: HitTestBehavior.opaque,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ambient Glow Ring 1
                Container(
                  width: 176,
                  height: 176,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF2E63).withOpacity(0.32),
                        const Color(0xFFFF2E63).withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Outer Border Ring 2
                Container(
                  width: 154,
                  height: 154,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFF2E63).withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),

                // Core Giant SOS Button (One-Click Instant)
                Container(
                  width: 138,
                  height: 138,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.2, -0.3),
                      radius: 0.85,
                      colors: [
                        Color(0xFFFF6584),
                        Color(0xFFFF2E63),
                        Color(0xFFD61348),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF2E63).withOpacity(0.7),
                        blurRadius: 30,
                        spreadRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "SOS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "One-Tap Alert",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Button: Send to WhatsApp
        _buildSideActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          label: "Send to\nWhatsApp",
          onTap: widget.onSendToWhatsApp ?? () {
            HapticFeedback.lightImpact();
            context.push('/emergency/active');
          },
        ),
      ],
    );
  }

  Widget _buildSideActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF131622).withOpacity(0.85),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.9),
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}
