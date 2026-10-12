import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rakshaa/core/utils/sound_service.dart';
import 'package:rakshaa/features/emergency/providers/emergency_provider.dart';
import 'package:rakshaa/core/services/app_location_service.dart';

class HomeMapBackground extends ConsumerStatefulWidget {
  final Map<String, dynamic>? userProfile;
  final VoidCallback? onNotificationTap;

  const HomeMapBackground({
    super.key,
    this.userProfile,
    this.onNotificationTap,
  });

  @override
  ConsumerState<HomeMapBackground> createState() => _HomeMapBackgroundState();
}

class _HomeMapBackgroundState extends ConsumerState<HomeMapBackground> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late LatLng _currentCenter;
  bool _hasLocation = false;
  bool _isMuted = SoundService.isMuted; // Default muted as requested
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Instantly retrieve cached location (0ms delay)
    _currentCenter = AppLocationService.currentLocation;
    _hasLocation = AppLocationService.hasAcquiredLocation;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    AppLocationService.addListener(_onLocationChanged);
    _initLiveLocation();
  }

  void _onLocationChanged(LatLng pos) {
    if (mounted) {
      final wasDefault = !_hasLocation;
      setState(() {
        _currentCenter = pos;
        _hasLocation = true;
      });
      if (wasDefault) {
        try {
          _mapController.move(pos, 15.5);
        } catch (_) {}
      }
      ref.read(emergencyProvider.notifier).updateLocation(pos.latitude, pos.longitude);
    }
  }

  @override
  void dispose() {
    AppLocationService.removeListener(_onLocationChanged);
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initLiveLocation() async {
    final pos = await AppLocationService.initializeLocation();
    if (mounted && (pos != _currentCenter || !_hasLocation)) {
      setState(() {
        _currentCenter = pos;
        _hasLocation = true;
      });
      try {
        _mapController.move(_currentCenter, 15.5);
      } catch (_) {}
      ref.read(emergencyProvider.notifier).updateLocation(pos.latitude, pos.longitude);
    }
  }

  void _recenterMap() {
    try {
      _mapController.move(_currentCenter, 16.0);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = widget.userProfile?['photoUrl'] ?? user?.photoURL ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';

    return SizedBox.expand(
      child: Stack(
        children: [
          // Flutter Map with Dark Matrix Filter for Cyber/Neon Theme
          ColorFiltered(
            colorFilter: const ColorFilter.matrix([
              -0.85, 0.0, 0.0, 0.0, 255.0, // Red Inversion
              0.0, -0.85, 0.0, 0.0, 255.0, // Green Inversion
              0.0, 0.0, -0.70, 0.0, 255.0, // Blue Inversion
              0.0, 0.0, 0.0, 1.0, 0.0,    // Alpha
            ]),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: 15.2,
                minZoom: 12,
                maxZoom: 18,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.rakshaa.app',
                ),
                MarkerLayer(
                  markers: [
                    // Landmark: City Park
                    Marker(
                      point: LatLng(_currentCenter.latitude + 0.0035, _currentCenter.longitude + 0.002),
                      width: 100,
                      height: 30,
                      child: _buildLandmarkBadge(Icons.park, "City Park", const Color(0xFF00E676)),
                    ),
                    // Landmark: Central Mall
                    Marker(
                      point: LatLng(_currentCenter.latitude - 0.0025, _currentCenter.longitude + 0.004),
                      width: 110,
                      height: 30,
                      child: _buildLandmarkBadge(Icons.shopping_bag_outlined, "Central Mall", Colors.white70),
                    ),
                    // Landmark: Metro Station
                    Marker(
                      point: LatLng(_currentCenter.latitude - 0.0042, _currentCenter.longitude + 0.0015),
                      width: 120,
                      height: 30,
                      child: _buildLandmarkBadge(Icons.train_outlined, "Metro Station", Colors.white70),
                    ),
                    // Landmark: Block A
                    Marker(
                      point: LatLng(_currentCenter.latitude + 0.0022, _currentCenter.longitude - 0.004),
                      width: 80,
                      height: 25,
                      child: const Text(
                        "Block A",
                        style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // User Location Hero Marker with Animated Wave & "You are here" tooltip
                    Marker(
                      point: _currentCenter,
                      width: 160,
                      height: 120,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing Outer Wave 1
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 50 + (35 * _pulseController.value),
                                height: 50 + (35 * _pulseController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF2E63).withOpacity(0.35 * (1.0 - _pulseController.value)),
                                ),
                              );
                            },
                          ),
                          // Pulsing Outer Wave 2
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 35 + (20 * _pulseController.value),
                                height: 35 + (20 * _pulseController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF2E63).withOpacity(0.5 * (1.0 - _pulseController.value)),
                                ),
                              );
                            },
                          ),
                          // Location Pin
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // "You are here" badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF131622).withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF2E63),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "You are here",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              // Glowing Red Pin
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF4D79), Color(0xFFFF2E63)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF2E63).withOpacity(0.8),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Gradient Fade to seamless deep dark background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF090A10).withOpacity(0.85),
                    const Color(0xFF090A10),
                  ],
                ),
              ),
            ),
          ),

          // Top Header Bar
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Avatar with online status
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                          image: DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF090A10), width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Shield Logo + App Name + Subtitle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2E63).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Color(0xFFFF2E63),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rakshaa",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          "Stay Safe, Always",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Mute / Unmute SOS Siren Sound Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _isMuted = SoundService.toggleMute();
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF131622),
                        duration: const Duration(milliseconds: 1600),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _isMuted ? Colors.white12 : const Color(0xFF00E676).withOpacity(0.3),
                          ),
                        ),
                        content: Row(
                          children: [
                            Icon(
                              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                              color: _isMuted ? const Color(0xFFFF2E63) : const Color(0xFF00E676),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isMuted ? "SOS Siren Muted" : "SOS Siren Sound Enabled 🔊",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161926).withOpacity(0.85),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isMuted
                            ? Colors.white.withOpacity(0.12)
                            : const Color(0xFF00E676).withOpacity(0.5),
                        width: _isMuted ? 1.0 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isMuted
                              ? Colors.black.withOpacity(0.3)
                              : const Color(0xFF00E676).withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: _isMuted ? Colors.white60 : const Color(0xFF00E676),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Notification Bell with unread badge
                GestureDetector(
                  onTap: widget.onNotificationTap ?? () {},
                  child: Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF161926).withOpacity(0.85),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 11,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF2E63),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Map Control Tools (Top-Right)
          Positioned(
            top: 75,
            right: 16,
            child: Column(
              children: [
                _buildMapToolButton(Icons.navigation_outlined, () {
                  _mapController.rotate(0);
                }),
                const SizedBox(height: 8),
                _buildMapToolButton(Icons.layers_outlined, () {}),
                const SizedBox(height: 8),
                _buildMapToolButton(Icons.my_location, _recenterMap),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapToolButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF161926).withOpacity(0.85),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 18),
        ),
      ),
    );
  }

  Widget _buildLandmarkBadge(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
