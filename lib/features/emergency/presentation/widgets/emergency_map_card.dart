import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import 'package:rakshaa/core/widgets/rakshaa_card.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/emergency_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class EmergencyMapCard extends ConsumerStatefulWidget {
  const EmergencyMapCard({super.key});

  @override
  ConsumerState<EmergencyMapCard> createState() => _EmergencyMapCardState();
}

class _EmergencyMapCardState extends ConsumerState<EmergencyMapCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _updateTimer;
  String _timeAgo = "Updated just now";
  Position? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _updateTimeAgo();
      }
    });
    
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() { _isLoading = false; });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() { _isLoading = false; });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() { _isLoading = false; });
        return;
      } 

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5),
        );
      } catch (_) {
        if (!kIsWeb) {
          try {
            position = await Geolocator.getLastKnownPosition();
          } catch (_) {}
        }
      }
      
      if (position == null) {
        throw Exception("Location unavailable");
      }
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });
        
        // Also update emergency provider if needed
        ref.read(emergencyProvider.notifier).updateLocation(position.latitude, position.longitude);
      }

      // SYNC TO FIRESTORE for Admin Dashboard!
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'latitude': position.latitude,
            'longitude': position.longitude,
          });
        }
      } catch (firestoreError) {
        debugPrint("Could not sync emergency location to Firestore: $firestoreError");
      }
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  void _updateTimeAgo() {
    final location = ref.read(emergencyProvider).location;
    if (location == null) return;
    
    final diff = DateTime.now().difference(location.updatedAt);
    setState(() {
      if (diff.inSeconds < 5) {
        _timeAgo = "Updated just now";
      } else if (diff.inSeconds < 60) {
        _timeAgo = "Updated ${diff.inSeconds} sec ago";
      } else {
        _timeAgo = "Updated ${diff.inMinutes} min ago";
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(emergencyProvider).location;
    final contactsCount = ref.watch(emergencyProvider).contacts.length;

    if (location == null) return const SizedBox.shrink();

    return RakshaaCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Live Location",
                      style: TextStyle(
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.softGreen, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          "Sharing with $contactsCount contacts",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  _timeAgo,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              border: const Border(
                top: BorderSide(color: AppColors.border),
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: ClipRRect(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.emergencyRed))
                  : _currentPosition != null
                      ? FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            initialZoom: 15.0,
                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.rakshaa.rakshaa',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                  width: 40,
                                  height: 40,
                                  child: AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (context, child) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 32 + (_pulseController.value * 40),
                                            height: 32 + (_pulseController.value * 40),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.emergencyRed.withAlpha(((0.15 * (1 - _pulseController.value)) * 255).toInt()),
                                            ),
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.emergencyRed,
                                              border: Border.all(color: Colors.white, width: 3),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.emergencyRed.withAlpha(100),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const Center(
                          child: Text("Map unavailable", style: TextStyle(color: AppColors.textSecondary)),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
