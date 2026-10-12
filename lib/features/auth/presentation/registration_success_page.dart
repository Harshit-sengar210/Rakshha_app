import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import '../providers/registration_provider.dart';

class RegistrationSuccessPage extends ConsumerStatefulWidget {
  const RegistrationSuccessPage({super.key});

  @override
  ConsumerState<RegistrationSuccessPage> createState() => _RegistrationSuccessPageState();
}

class _RegistrationSuccessPageState extends ConsumerState<RegistrationSuccessPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotScale;
  late Animation<double> _circleScale;
  late Animation<double> _shieldOpacity;
  late Animation<double> _shieldScale;
  late Animation<double> _textOpacity;
  late Animation<double> _listOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800));

    _dotScale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.15, curve: Curves.easeOutCubic)));
    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.15, 0.40, curve: Curves.elasticOut)));
    _shieldOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.50, curve: Curves.easeIn)));
    _shieldScale = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.60, curve: Curves.elasticOut)));
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.60, 0.80, curve: Curves.easeIn)));
    _listOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.75, 1.0, curve: Curves.easeIn)));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: AppColors.softGreen, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.deepNavy)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDFC),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_controller.value > 0.0 && _controller.value < 0.2)
                            Transform.scale(
                              scale: _dotScale.value,
                              child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: AppColors.rakshaaCoral, shape: BoxShape.circle)),
                            ),
                          if (_controller.value >= 0.15)
                            Transform.scale(
                              scale: _circleScale.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.rakshaaCoral.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          if (_controller.value >= 0.15)
                            Transform.scale(
                              scale: _circleScale.value * 0.75,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.rakshaaCoral.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          if (_controller.value >= 0.35)
                            Opacity(
                              opacity: _shieldOpacity.value,
                              child: Transform.scale(
                                scale: _shieldScale.value,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.rakshaaCoral,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: AppColors.rakshaaCoral.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)],
                                  ),
                                  child: const Icon(Icons.shield, color: Colors.white, size: 40),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Opacity(
                      opacity: _textOpacity.value,
                      child: Column(
                        children: const [
                          Text("You're All Set!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.deepNavy, letterSpacing: -1)),
                          SizedBox(height: 12),
                          Text("Your Rakshaa account is ready.\nStay safe and stay connected.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF71809A), height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    Opacity(
                      opacity: _listOpacity.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCheckItem("Account created"),
                          _buildCheckItem("Number verified"),
                          _buildCheckItem("Priority contact added"),
                          _buildCheckItem("Safety setup complete"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),
                    Opacity(
                      opacity: _listOpacity.value,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(registrationProvider.notifier).clear();
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.rakshaaCoral,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                          elevation: 4,
                          shadowColor: AppColors.rakshaaCoral.withOpacity(0.4),
                        ),
                        child: const Text("Continue to Rakshaa →", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
