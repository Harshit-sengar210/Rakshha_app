import 'package:flutter/material.dart';
import 'package:rakshaa/core/constants/app_colors.dart';


class LoginIllustration extends StatefulWidget {
  final AnimationController entranceController;

  const LoginIllustration({super.key, required this.entranceController});

  @override
  State<LoginIllustration> createState() => _LoginIllustrationState();
}

class _LoginIllustrationState extends State<LoginIllustration> with TickerProviderStateMixin {
  late Animation<double> _mainScale;
  late Animation<double> _mainOpacity;
  late Animation<double> _shieldScale;
  late Animation<double> _heartsOpacity;

  late AnimationController _breathingController;
  late Animation<double> _breathingY;

  @override
  void initState() {
    super.initState();

    _mainOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.40, 0.60, curve: Curves.easeIn)),
    );
    _mainScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.40, 0.65, curve: Curves.easeOutCubic)),
    );
    _shieldScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.50, 0.70, curve: Curves.elasticOut)),
    );
    _heartsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.entranceController, curve: const Interval(0.55, 0.75, curve: Curves.easeIn)),
    );

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathingY = Tween<double>(begin: 0, end: -2.0).animate(
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
    return AnimatedBuilder(
      animation: Listenable.merge([widget.entranceController, _breathingController]),
      builder: (context, child) {
        return Opacity(
          opacity: _mainOpacity.value,
          child: Transform.scale(
            scale: _mainScale.value,
            child: SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Soft abstract background shapes
                  Positioned(
                    left: 40,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softBlush.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 80,
                    top: 20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softBlush.withOpacity(0.5),
                      ),
                    ),
                  ),
                  
                  // Main Character Shape (Abstracted via Icons/Shapes since we lack a real asset)
                  // Using a combination of shapes to mock the woman illustration
                  Positioned(
                    bottom: 0,
                    left: 60,
                    child: Transform.translate(
                      offset: Offset(0, _breathingY.value),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Hair/Head silhouette
                          Container(
                            width: 80,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C3E50), // dark hair
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                          ),
                          // Face shape
                          Positioned(
                            top: 20,
                            right: 10,
                            child: Container(
                              width: 50,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFD1C1), // skin tone
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Body/Shirt
                          Container(
                            width: 130,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.rakshaaCoral.withOpacity(0.85),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                            ),
                          ),
                          // Phone block
                          Positioned(
                            right: 10,
                            bottom: 30,
                            child: Transform.rotate(
                              angle: -0.2,
                              child: Container(
                                width: 24,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.deepNavy,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Shield overlay
                  Positioned(
                    top: 40,
                    right: 110,
                    child: Transform.scale(
                      scale: _shieldScale.value,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.rakshaaCoral.withOpacity(0.15),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shield, color: AppColors.rakshaaCoral, size: 28),
                      ),
                    ),
                  ),
                  
                  // Decorative text & hearts
                  Positioned(
                    right: 20,
                    top: 60,
                    child: Opacity(
                      opacity: _heartsOpacity.value,
                      child: Transform.rotate(
                        angle: -0.15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Safe",
                              style: TextStyle(
                                fontFamily: 'Caveat', // Fallback
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.rakshaaCoral,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "Stronger",
                              style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.rakshaaCoral,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              "Together ♡",
                              style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.rakshaaCoral,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
