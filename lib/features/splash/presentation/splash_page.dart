import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoPulseController;
  late AnimationController _radarWaveController;
  late AnimationController _textFadeController;
  late AnimationController _exitController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  String _statusMessage = "Initializing safety systems...";
  int _statusStep = 0;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();

    // 1. Logo breathing & entrance animation
    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeOutBack),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeIn),
    );

    // 2. Radar wave ripple around the shield
    _radarWaveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 3. Text & tagline slide up
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeIn),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeOutCubic),
    );

    // 4. Exit zoom animation
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _startSplashSequence();
  }

  void _startSplashSequence() {
    // Start Logo Entrance
    _logoPulseController.forward();

    // Fade in text after 400ms
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textFadeController.forward();
    });

    // Step 1 status
    _statusTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _statusStep = 1;
          _statusMessage = "Calibrating GPS live tracking...";
        });
      }
    });

    // Step 2 status
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _statusStep = 2;
          _statusMessage = "Connecting WhatsApp emergency gateway...";
        });
      }
    });

    // Step 3 status
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (mounted) {
        HapticFeedback.lightImpact();
        setState(() {
          _statusStep = 3;
          _statusMessage = "Safety Shield: ACTIVE & OPERATIONAL";
        });
      }
    });

    // Navigate out at 3.3s
    Future.delayed(const Duration(milliseconds: 3300), () async {
      if (!mounted) return;

      await _exitController.forward();

      if (!mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _logoPulseController.dispose();
    _radarWaveController.dispose();
    _textFadeController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: AnimatedBuilder(
        animation: _exitController,
        builder: (context, child) {
          final exitScale = Tween<double>(begin: 1.0, end: 1.1).evaluate(
            CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
          );
          final exitOpacity = Tween<double>(begin: 1.0, end: 0.0).evaluate(
            CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
          );

          return Opacity(
            opacity: exitOpacity,
            child: Transform.scale(
              scale: exitScale,
              child: Stack(
                children: [
                  // Ambient Cyber Grid & Glow Orbs
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0, -0.2),
                          radius: 1.1,
                          colors: [
                            Color(0x33FF2E63),
                            Color(0x10131622),
                            Color(0xFF090A10),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top ambient light flare
                  Positioned(
                    top: -60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF2E63).withOpacity(0.12),
                        ),
                      ),
                    ),
                  ),

                  // Main Content
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 3),

                            // Glowing 3D App Logo Icon & Radar Rings
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Concentric Radar Ripple 1
                                AnimatedBuilder(
                                  animation: _radarWaveController,
                                  builder: (context, child) {
                                    final progress = _radarWaveController.value;
                                    return Container(
                                      width: 170 + (progress * 70),
                                      height: 170 + (progress * 70),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFFF2E63).withOpacity((1.0 - progress) * 0.4),
                                          width: 1.5,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Concentric Radar Ripple 2
                                AnimatedBuilder(
                                  animation: _radarWaveController,
                                  builder: (context, child) {
                                    final progress = (_radarWaveController.value + 0.5) % 1.0;
                                    return Container(
                                      width: 170 + (progress * 70),
                                      height: 170 + (progress * 70),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFFF4D79).withOpacity((1.0 - progress) * 0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Glow Halo Behind Logo
                                Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF2E63).withOpacity(0.4),
                                        blurRadius: 36,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),

                                // 3D App Logo Container
                                AnimatedBuilder(
                                  animation: _logoPulseController,
                                  builder: (context, child) {
                                    return FadeTransition(
                                      opacity: _logoFade,
                                      child: Transform.scale(
                                        scale: _logoScale.value,
                                        child: Container(
                                          width: 135,
                                          height: 135,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: const Color(0xFFFF2E63).withOpacity(0.6),
                                              width: 2.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFFF2E63).withOpacity(0.5),
                                                blurRadius: 24,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(28),
                                            child: Image.asset(
                                              'assets/images/app_logo.png',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                // High-tech fallback icon if asset is loading
                                                return Container(
                                                  color: const Color(0xFF131622),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.shield_rounded,
                                                      color: Color(0xFFFF2E63),
                                                      size: 60,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 36),

                            // App Wordmark & Tagline
                            SlideTransition(
                              position: _textSlide,
                              child: FadeTransition(
                                opacity: _textFade,
                                child: Column(
                                  children: [
                                    // "Rakshaa" Title with Gradient
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color(0xFFFF85A1),
                                          Color(0xFFFF2E63),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds),
                                      child: const Text(
                                        "Rakshaa",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 38,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Subtitle
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF131622),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.08),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        "STAY SAFE, ALWAYS",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white.withOpacity(0.7),
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const Spacer(flex: 3),

                            // Live Security Diagnostic Step & Progress
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131622).withOpacity(0.85),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _statusStep == 3
                                      ? const Color(0xFF00E676).withOpacity(0.4)
                                      : Colors.white.withOpacity(0.08),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_statusStep == 3)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF00E676),
                                      size: 16,
                                    )
                                  else
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          _statusStep == 2
                                              ? const Color(0xFF25D366)
                                              : const Color(0xFFFF2E63),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _statusMessage,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: _statusStep == 3 ? FontWeight.w700 : FontWeight.w500,
                                      color: _statusStep == 3
                                          ? const Color(0xFF00E676)
                                          : Colors.white.withOpacity(0.8),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
