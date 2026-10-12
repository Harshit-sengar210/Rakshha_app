import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rakshaa/core/constants/app_colors.dart';
import 'package:rakshaa/core/constants/app_constants.dart';
import 'package:rakshaa/core/widgets/rakshaa_card.dart';
import 'package:flutter/foundation.dart';

class LiveLocationCard extends ConsumerStatefulWidget {
  const LiveLocationCard({super.key});

  @override
  ConsumerState<LiveLocationCard> createState() => _LiveLocationCardState();
}

class _LiveLocationCardState extends ConsumerState<LiveLocationCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Position? _currentPosition;
  bool _isLoading = true;
  String _statusMessage = "Locating...";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    if (!kIsWeb) {
      try {
        Geolocator.getLastKnownPosition().then((pos) {
          if (pos != null && mounted && _isLoading) {
            setState(() {
              _currentPosition = pos;
              _isLoading = false;
              _statusMessage = "Active";
            });
          }
        }).catchError((_) {});
      } catch (_) {}
    }
    
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _statusMessage = "Location permissions denied"; _isLoading = false; });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() { _statusMessage = "Location permissions permanently denied"; _isLoading = false; });
        return;
      } 

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (_statusMessage.contains("disabled")) {
          await Geolocator.openLocationSettings();
        }
        setState(() { _statusMessage = "Location services disabled. Tap to open settings."; _isLoading = false; });
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
        throw Exception("Location unavailable on device");
      }
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLoading = false;
          _statusMessage = "Active";
        });
      }
      
      // SYNC TO FIRESTORE for the Admin Panel!
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'latitude': position.latitude,
            'longitude': position.longitude,
          });
        }
      } catch (firestoreError) {
        debugPrint("Could not sync location to Firestore: $firestoreError");
      }
    } catch (e) {
      debugPrint("LiveLocationCard error: $e");
      if (mounted) {
        setState(() {
          _statusMessage = "Error getting location";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RakshaaCard(
      onTap: _determinePosition,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Live Location",
                style: TextStyle(
                  color: AppColors.deepNavy,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _currentPosition != null ? AppColors.softGreen.withAlpha((( 0.1 * 255 ).toInt())) : Colors.grey.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _currentPosition != null ? Icons.check_circle : Icons.sync, 
                      color: _currentPosition != null ? AppColors.softGreen : Colors.grey, 
                      size: 12
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _currentPosition != null ? AppColors.softGreen : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Sharing with trusted contacts",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rakshaaCoral))
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
                                            width: 24 + (_pulseController.value * 16),
                                            height: 24 + (_pulseController.value * 16),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.rakshaaCoral.withAlpha((0.3 * (1 - _pulseController.value) * 255).toInt()),
                                            ),
                                          ),
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.rakshaaCoral,
                                              border: Border.all(color: Colors.white, width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.rakshaaCoral.withAlpha((( 0.4 * 255 ).toInt())),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
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
