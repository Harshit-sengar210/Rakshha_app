import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';


class RakshaaLogoAnimation extends StatefulWidget {
  const RakshaaLogoAnimation({super.key});

  @override
  State<RakshaaLogoAnimation> createState() => _RakshaaLogoAnimationState();
}

class _RakshaaLogoAnimationState extends State<RakshaaLogoAnimation> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  
  late Animation<double> _dotOpacity;
  late Animation<double> _dotScale;
  
  late Animation<double> _shieldDrawProgress;
  
  late Animation<double> _heartOpacity;
  late Animation<double> _heartScale;
  
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    
    // Main sequence controller (0s -> ~1.5s total mapped to 0.0 -> 1.0)
    // 0.0 - 0.25s: Dot
    // 0.40 - 1.1s: Shield
    // 1.15 - 1.45s: Heart
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _dotOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.13, 0.20, curve: Curves.easeIn), // roughly 0.2s
      ),
    );
    
    _dotScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.13, 0.27, curve: Curves.easeOutBack), // roughly 0.2 - 0.4s
      ),
    );
    
    _shieldDrawProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.27, 0.75, curve: Curves.easeInOutCubic), // 0.40s - 1.1s
      ),
    );
    
    _heartOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.79, 1.0, curve: Curves.easeIn), // 1.15s - 1.45s
      ),
    );
    
    _heartScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.79, 1.0, curve: Curves.easeOutBack), // 1.15s - 1.45s
      ),
    );
    
    _pulseScale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );
    
    _pulseOpacity = Tween<double>(begin: 0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.forward();
      }
    });

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _pulseController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Soft glow background
            if (_mainController.isCompleted)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 0.06),
                duration: const Duration(seconds: 1),
                builder: (context, val, _) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.rakshaaCoral.withOpacity(val),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
              
            // Pulse effect
            if (_pulseController.isAnimating)
              Opacity(
                opacity: _pulseOpacity.value,
                child: Transform.scale(
                  scale: _pulseScale.value,
                  child: Container(
                    width: 60,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.rakshaaCoral, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            
            // The shield drawing
            CustomPaint(
              size: const Size(64, 76),
              painter: _ShieldPainter(
                progress: _shieldDrawProgress.value,
                color: AppColors.rakshaaCoral,
              ),
            ),
            
            // Initial Dot
            if (_shieldDrawProgress.value < 0.1)
              Opacity(
                opacity: _dotOpacity.value,
                child: Transform.scale(
                  scale: _dotScale.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.rakshaaCoral,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              
            // Heart
            Opacity(
              opacity: _heartOpacity.value,
              child: Transform.scale(
                scale: _heartScale.value,
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.rakshaaCoral,
                  size: 24,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ShieldPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Start at top center
    path.moveTo(size.width / 2, 0);
    // Draw right top flat
    path.lineTo(size.width, size.height * 0.15);
    // Draw right side straight down
    path.lineTo(size.width, size.height * 0.5);
    // Draw right bottom curve to center
    path.quadraticBezierTo(size.width, size.height * 0.85, size.width / 2, size.height);
    // Draw left bottom curve to left side
    path.quadraticBezierTo(0, size.height * 0.85, 0, size.height * 0.5);
    // Draw left side straight up
    path.lineTo(0, size.height * 0.15);
    // Close back to top center
    path.close();

    // Create metrics to draw path partially
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;
    
    final metric = pathMetrics.first;
    final extractPath = metric.extractPath(0.0, metric.length * progress);
    
    // Draw white interior
    if (progress > 0.95) {
      final fillPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawPath(extractPath, fillPaint);
    }
    
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
