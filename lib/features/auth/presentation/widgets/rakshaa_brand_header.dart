import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'dart:math' as math;

class RakshaaBrandHeader extends StatefulWidget {
  final AnimationController entranceController;

  const RakshaaBrandHeader({super.key, required this.entranceController});

  @override
  State<RakshaaBrandHeader> createState() => _RakshaaBrandHeaderState();
}

class _RakshaaBrandHeaderState extends State<RakshaaBrandHeader> with SingleTickerProviderStateMixin {
  late Animation<double> _logoOpacity;
  late Animation<double> _logoTranslate;
  late Animation<double> _wordmarkScale;
  late Animation<double> _wordmarkOpacity;
  late Animation<double> _taglineOpacity;

  late AnimationController _bellController;
  late Animation<double> _bellRotation;

  @override
  void initState() {
    super.initState();

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.06, 0.33, curve: Curves.easeOut)),
    );
    _logoTranslate = Tween<double>(begin: -10.0, end: 0.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.06, 0.33, curve: Curves.easeOut)),
    );

    _wordmarkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.16, 0.40, curve: Curves.easeOut)),
    );
    _wordmarkScale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.16, 0.40, curve: Curves.easeOut)),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.23, 0.46, curve: Curves.easeIn)),
    );

    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bellRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -4.0 * (math.pi / 180)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -4.0 * (math.pi / 180), end: 4.0 * (math.pi / 180)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0 * (math.pi / 180), end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _bellController, curve: Curves.easeInOut));

    widget.entranceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bellController.forward();
      }
    });
  }

  @override
  void dispose() {
    _bellController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: widget.entranceController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _logoTranslate.value),
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(Icons.shield_outlined, color: AppColors.rakshaaCoral, size: 40),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Icon(Icons.favorite, color: AppColors.rakshaaCoral, size: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: widget.entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _wordmarkOpacity.value,
                      child: Transform.scale(
                        scale: _wordmarkScale.value,
                        child: const Text(
                          "Rakshaa",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepNavy,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: widget.entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _taglineOpacity.value,
                      child: const Text(
                        "Your Safety. Always Within Reach.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF71809A), // mutedBlue
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
