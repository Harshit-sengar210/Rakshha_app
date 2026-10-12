import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'dart:math' as math;

class SafetyOrbit extends StatefulWidget {
  const SafetyOrbit({super.key});

  @override
  State<SafetyOrbit> createState() => _SafetyOrbitState();
}

class _SafetyOrbitState extends State<SafetyOrbit> with TickerProviderStateMixin {
  late AnimationController _drawController;
  late AnimationController _rotateController;
  late Animation<double> _drawProgress;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _drawProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _drawController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Delayed start for orbit
    Future.delayed(const Duration(milliseconds: 2050), () {
      if (mounted) {
        _drawController.forward().then((_) {
          if (mounted) {
            _rotateController.repeat();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _drawController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_drawController, _rotateController]),
      builder: (context, child) {
        if (_drawProgress.value == 0) return const SizedBox.shrink();

        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(200, 200),
              painter: _OrbitPainter(progress: _drawProgress.value),
            ),
            if (_drawProgress.value > 0.9)
              Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      _buildParticle(0, Icons.shield_outlined),
                      _buildParticle(math.pi * 2 / 3, Icons.location_on),
                      _buildParticle(math.pi * 4 / 3, Icons.people),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildParticle(double angle, IconData icon) {
    final radius = 100.0;
    final x = radius + radius * math.cos(angle) - 8;
    final y = radius + radius * math.sin(angle) - 8;

    return Positioned(
      left: x,
      top: y,
      child: Transform.rotate(
        // Counter-rotate to keep icon upright
        angle: -(_rotateController.value * 2 * math.pi),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.rakshaaCoral, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.rakshaaCoral.withOpacity(0.2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: 8, color: AppColors.rakshaaCoral),
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;

  _OrbitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.rakshaaCoral.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    // Draw an incomplete circle (e.g. 80% of a circle)
    final sweepAngle = 2 * math.pi * 0.8 * progress;
    canvas.drawArc(rect, -math.pi / 4, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
