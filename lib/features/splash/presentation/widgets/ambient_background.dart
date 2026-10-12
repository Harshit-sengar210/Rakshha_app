import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';

class AmbientBackground extends StatefulWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _topRightScale;
  late Animation<double> _bottomLeftScale;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _topRightScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _bottomLeftScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFDFC), // warm white
      child: Stack(
        children: [
          // Top-right glow
          Positioned(
            top: -150,
            right: -100,
            child: AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _topRightScale.value,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.rakshaaCoral.withOpacity(0.04),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.rakshaaCoral.withOpacity(0.04),
                          blurRadius: 100,
                          spreadRadius: 100,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom-left glow
          Positioned(
            bottom: -150,
            left: -150,
            child: AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bottomLeftScale.value,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFDE4EC).withOpacity(0.4), // warm pink
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFDE4EC).withOpacity(0.4),
                          blurRadius: 80,
                          spreadRadius: 80,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
