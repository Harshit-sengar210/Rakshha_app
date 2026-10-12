import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../providers/home_provider.dart';
import 'widgets/home_map_background.dart';
import 'widgets/home_greeting_card.dart';
import 'widgets/home_hero_sos_section.dart';
import 'widgets/rakshaa_bottom_nav.dart';
import 'package:rakshaa/core/utils/sound_service.dart';
import 'package:rakshaa/core/services/location_permission_service.dart';
import 'package:rakshaa/features/emergency/providers/emergency_provider.dart' hide EmergencyState;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _sosExpandController;
  late Animation<double> _sosScaleAnimation;

  static bool _hasRequestedLocation = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _sosExpandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _sosScaleAnimation = CurvedAnimation(
      parent: _sosExpandController,
      curve: Curves.easeInOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_hasRequestedLocation) return;
      _hasRequestedLocation = true;

      await LocationPermissionService.requestAllLocationPermissions(context: mounted ? context : null);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _sosExpandController.dispose();
    super.dispose();
  }

  void _triggerSosWithFluidAnimation() async {
    // 1. Immediately start emergency sequence & dispatch WhatsApp alerts to contacts
    ref.read(emergencyProvider.notifier).startEmergency(forceRestart: true);
    
    // 2. Play siren ringtone (if unmuted) & vibration
    SoundService.playEmergencySiren();
    ref.read(homeProvider.notifier).setEmergencyState(EmergencyState.activating);
    
    // 3. Start full screen fluid radial expansion animation
    await _sosExpandController.forward();
    
    if (mounted) {
      context.push('/emergency/active');
      
      // Reset after transition finishes smoothly
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _sosExpandController.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final user = FirebaseAuth.instance.currentUser;

    // Prefer Firestore fullName, fall back to displayName or 'Rohit'
    final String rawName = userProfile.value?['fullName']?.toString()
        ?? user?.displayName
        ?? 'Rohit';
    final String userName = rawName.trim().split(' ').first;

    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Main App UI (Non-scrollable, responsive layout)
            FadeTransition(
              opacity: _entranceController,
              child: Column(
                children: [
                  // 1. Map Section + Header + Linear Gradient Greeting Card
                  Expanded(
                    child: Stack(
                      children: [
                        // Interactive Map Background (fills available space)
                        Positioned.fill(
                          child: HomeMapBackground(
                            userProfile: userProfile.value,
                            onNotificationTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFF131622),
                                  content: Text("All safety shield systems operational."),
                                ),
                              );
                            },
                          ),
                        ),

                        // Linear Gradient Greeting Card anchored at bottom of map
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 8,
                          child: HomeGreetingCard(
                            userName: userName,
                            onLiveTap: () async {
                              final granted = await LocationPermissionService.requestAllLocationPermissions(context: context);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF131622),
                                    content: Text(
                                      granted
                                          ? "Live GPS tracking & location sharing is active."
                                          : "Location permission is needed for live tracking.",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 2. Giant Hero SOS Button Section in the bottom center above bottom nav
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeHeroSosSection(
                      onTriggerEmergency: _triggerSosWithFluidAnimation,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 3. Bottom Navigation Bar
                  const RakshaaBottomNav(),
                ],
              ),
            ),

            // Fluid Full-Screen SOS Radial Expansion Overlay
            AnimatedBuilder(
              animation: _sosScaleAnimation,
              builder: (context, child) {
                if (_sosScaleAnimation.value == 0) return const SizedBox.shrink();

                return Positioned.fill(
                  child: IgnorePointer(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Fluid Expanding Circle centered on SOS button
                        Positioned(
                          bottom: 75,
                          child: Transform.scale(
                            scale: 1.0 + (_sosScaleAnimation.value * 28.0),
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFFFF4D79),
                                    Color(0xFFFF2E63),
                                    Color(0xFFD61348),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Center Shield Icon fading during explosion
                        Positioned(
                          bottom: 110,
                          child: Opacity(
                            opacity: (1.0 - (_sosScaleAnimation.value * 2.0)).clamp(0.0, 1.0),
                            child: const Icon(
                              Icons.shield_outlined,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
