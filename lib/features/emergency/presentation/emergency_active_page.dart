import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:geolocator/geolocator.dart';
import '../../home/providers/home_provider.dart';
import '../providers/emergency_provider.dart';
import '../models/emergency_session.dart';
import 'package:rakshaa/core/services/location_permission_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rakshaa/features/contacts/providers/contacts_provider.dart';
import 'package:rakshaa/core/services/app_location_service.dart';

class EmergencyActivePage extends ConsumerStatefulWidget {
  const EmergencyActivePage({super.key});

  @override
  ConsumerState<EmergencyActivePage> createState() => _EmergencyActivePageState();
}

class _EmergencyActivePageState extends ConsumerState<EmergencyActivePage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late AnimationController _ecgController;
  late AnimationController _holdController;

  Timer? _elapsedTimer;
  int _secondsElapsed = 0;
  bool _isHoldingStop = false;

  final MapController _mapController = MapController();
  LatLng _userPosition = AppLocationService.currentLocation;
  StreamSubscription<Position>? _positionStreamSub;

  @override
  void initState() {
    super.initState();
    // Instantly use cached location (0ms)
    _userPosition = AppLocationService.currentLocation;
    final initialLoc = ref.read(emergencyProvider).location;
    if (initialLoc != null && initialLoc.latitude != 0 && initialLoc.longitude != 0) {
      _userPosition = LatLng(initialLoc.latitude, initialLoc.longitude);
    }

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _ecgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500), // Hold for stop
    );

    _holdController.addListener(() {
      setState(() {});
      if (_holdController.value == 0.5) {
        HapticFeedback.mediumImpact();
      }
    });

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopEmergencyMode();
      }
    });

    // Start timer counter
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(emergencyProvider).session?.status != EmergencyStatus.active) {
        ref.read(emergencyProvider.notifier).startEmergency();
      }
      _fetchLocation();
    });
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    _entranceController.dispose();
    _pulseController.dispose();
    _ecgController.dispose();
    _holdController.dispose();
    _elapsedTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    try {
      await LocationPermissionService.requestAllLocationPermissions(context: mounted ? context : null);

      // Fast check OS last known position (0-5ms)
      final lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null && mounted && lastPos.latitude != 0 && lastPos.longitude != 0) {
        setState(() {
          _userPosition = LatLng(lastPos.latitude, lastPos.longitude);
        });
        try {
          _mapController.move(_userPosition, 16.0);
        } catch (_) {}
        AppLocationService.updateLocation(lastPos.latitude, lastPos.longitude);
        ref.read(emergencyProvider.notifier).updateLocation(lastPos.latitude, lastPos.longitude);
      }

      // Background high-accuracy position fetch
      Position? currentPos;
      try {
        currentPos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 4),
          ),
        );
      } catch (_) {}

      if (currentPos != null && mounted && currentPos.latitude != 0 && currentPos.longitude != 0) {
        final freshPos = currentPos;
        setState(() {
          _userPosition = LatLng(freshPos.latitude, freshPos.longitude);
        });
        try {
          _mapController.move(_userPosition, 16.0);
        } catch (_) {}
        AppLocationService.updateLocation(freshPos.latitude, freshPos.longitude);
        ref.read(emergencyProvider.notifier).updateLocation(freshPos.latitude, freshPos.longitude);
      }

      // Start continuous real-time position stream
      _startLiveLocationStream();
    } catch (e) {
      debugPrint("Emergency location error: $e");
    }
  }

  void _startLiveLocationStream() {
    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      );
      _positionStreamSub?.cancel();
      _positionStreamSub = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position pos) {
          if (mounted && pos.latitude != 0 && pos.longitude != 0) {
            setState(() {
              _userPosition = LatLng(pos.latitude, pos.longitude);
            });
            try {
              _mapController.move(_userPosition, 16.0);
            } catch (_) {}
            ref.read(emergencyProvider.notifier).updateLocation(pos.latitude, pos.longitude);
          }
        },
        onError: (e) {
          debugPrint("Emergency position stream error: $e");
        },
      );
    } catch (e) {
      debugPrint("Error starting emergency location stream: $e");
    }
  }

  void _stopEmergencyMode() {
    HapticFeedback.heavyImpact();
    ref.read(emergencyProvider.notifier).resolveEmergency();
    _holdController.reset();
    setState(() {
      _isHoldingStop = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00E676),
        content: Text("Emergency Mode Resolved. Contacts notified."),
      ),
    );

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  Future<void> _onPopInvoked(bool didPop, dynamic result) async {
    if (didPop) return;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131622),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Emergency Mode is active", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to leave this screen? Your emergency session will continue in the background.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Stay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Leave Screen", style: TextStyle(color: Color(0xFFFF2E63))),
          ),
        ],
      ),
    );

    if (shouldLeave == true && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF131622),
            content: Text("No valid phone number found for this contact."),
          ),
        );
      }
      return;
    }

    final Uri launchUri = Uri.parse('tel:$cleanNumber');
    debugPrint("[Quick Call] Launching phone dialer for: $cleanNumber (URI: $launchUri)");

    try {
      if (kIsWeb) {
        // On Web, platformDefault triggers the browser/device calling handler without popup blocking
        await launchUrl(launchUri, mode: LaunchMode.platformDefault);
      } else {
        // On Android / iOS, externalApplication directly routes to the Phone dialer app
        final launched = await launchUrl(launchUri, mode: LaunchMode.externalApplication);
        if (!launched) {
          await launchUrl(launchUri);
        }
      }
    } catch (e) {
      debugPrint("Primary dialer launch failed: $e. Attempting fallback...");
      try {
        await launchUrl(launchUri);
      } catch (err) {
        debugPrint("Dialer fallback also failed: $err");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF131622),
              content: Text("Could not open dialer for $cleanNumber"),
            ),
          );
        }
      }
    }
  }

  String _formatTimer(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final contactsState = ref.watch(contactsProvider);
    final userProfile = ref.watch(userProfileProvider);
    
    // Priority Contact Resolution
    String pName = '';
    String pPhone = '';
    final priorityContact = contactsState.priorityContact;
    if (priorityContact != null && priorityContact.phone.isNotEmpty) {
      pName = priorityContact.name;
      pPhone = priorityContact.phone;
    } else {
      final pData = userProfile.value?['priorityContact'];
      pName = pData?['name']?.toString() ?? 'Priority Contact';
      pPhone = pData?['phone']?.toString() ?? pData?['mobile']?.toString() ?? '';
    }

    // Comprehensive fallback if pPhone is empty: check first priority contact in list
    if (pPhone.isEmpty && contactsState.contacts.isNotEmpty) {
      final pC = contactsState.contacts.firstWhere(
        (c) => c.isPriority && c.phone.isNotEmpty,
        orElse: () => contactsState.contacts.first,
      );
      pPhone = pC.phone;
      if (pName.isEmpty || pName == 'Priority Contact') pName = pC.name;
    }

    // Comprehensive resolution of ALL active and trusted contacts
    final List<Map<String, dynamic>> allDisplayContacts = [];

    // 1. Priority Contact
    if (pName.isNotEmpty || pPhone.isNotEmpty) {
      allDisplayContacts.add({
        'name': pName.isNotEmpty ? pName : 'Priority Contact',
        'phone': pPhone,
        'relationship': 'Priority',
        'isPriority': true,
        'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      });
    }

    // 2. All Trusted Contacts (including newly added contacts)
    final avatarList = [
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
    ];

    if (contactsState.emergencyContacts.isNotEmpty) {
      for (int i = 0; i < contactsState.emergencyContacts.length; i++) {
        final c = contactsState.emergencyContacts[i];
        allDisplayContacts.add({
          'name': c.name.isNotEmpty ? c.name : 'Trusted Contact',
          'phone': c.phone,
          'relationship': c.relationship.isNotEmpty ? c.relationship : 'Trusted',
          'isPriority': false,
          'imageUrl': avatarList[i % avatarList.length],
        });
      }
    } else {
      final tcData = userProfile.value?['trustedContacts'];
      if (tcData is List && tcData.isNotEmpty) {
        for (int i = 0; i < tcData.length; i++) {
          final c = tcData[i];
          if (c is Map) {
            allDisplayContacts.add({
              'name': c['name']?.toString() ?? 'Trusted Contact',
              'phone': c['phone']?.toString() ?? '',
              'relationship': c['relationship']?.toString() ?? 'Trusted',
              'isPriority': false,
              'imageUrl': avatarList[i % avatarList.length],
            });
          }
        }
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        backgroundColor: const Color(0xFF090A10),
        body: SafeArea(
          child: FadeTransition(
            opacity: _entranceController,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Back Button
                  _buildBackButton(),
                  const SizedBox(height: 16),

                  // 2. "Emergency Mode Active" Hero Banner Card with ECG Wave
                  _buildEmergencyModeActiveCard(),
                  const SizedBox(height: 14),

                  // 3. Digital Elapsed Timer ("00:00:10") & Live Pill
                  _buildEmergencyTimerCard(),
                  const SizedBox(height: 14),

                  // 4. Live Location Map Card with Concentric Radar Pulse
                  _buildLiveLocationMapCard(contactsCount: allDisplayContacts.length),
                  const SizedBox(height: 14),

                  // 5. "Alerts Sent To" Card (Priority + ALL Trusted Contacts)
                  _buildAlertsSentToCard(allDisplayContacts),
                  const SizedBox(height: 14),

                  // 6. Quick Emergency Calling Dual Action Cards (Call Police 112 & Call Priority Contact)
                  _buildQuickCallingCards(
                    priorityName: pName,
                    priorityPhone: pPhone,
                  ),
                  const SizedBox(height: 20),

                  // 7. "Stop Emergency Mode" Hero Action Button (Hold for 3s)
                  _buildStopEmergencyButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Back Button ---
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF131622).withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  // --- Card 1: Emergency Mode Active Hero Card with ECG Wave ---
  Widget _buildEmergencyModeActiveCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF38101E).withOpacity(0.85),
            const Color(0xFF220B16).withOpacity(0.9),
            const Color(0xFF130910).withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF2E63).withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2E63).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Glowing Circular Warning Triangle
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFF5277),
                  Color(0xFFFF2E63),
                  Color(0xFFB00836),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF2E63).withOpacity(0.65),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "EMERGENCY MODE ACTIVE",
                  style: TextStyle(
                    color: Color(0xFFFF8FA3),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  "Help has been alerted.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Stay calm. You are not alone.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Animated ECG / Heartbeat Pulse Line
          CustomPaint(
            size: const Size(48, 40),
            painter: _EcgWavePainter(_ecgController),
          ),
        ],
      ),
    );
  }

  // --- Card 2: Digital Timer ("00:00:10") & Live Status ---
  Widget _buildEmergencyTimerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          // Stopwatch Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2E63).withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: Color(0xFFFF2E63),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Digital Timer & Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTimer(_secondsElapsed),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  "Emergency active for",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Live Red Pulsing Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFF2E63).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFF2E63).withOpacity(0.4),
                width: 0.9,
              ),
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
                    boxShadow: [
                      BoxShadow(color: Color(0xFFFF2E63), blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Live",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Card 3: Live Location Map Card with Concentric Radar Pulse ---
  Widget _buildLiveLocationMapCard({int contactsCount = 2}) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF131622),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // FlutterMap with Dark Matrix Filter
          ColorFiltered(
            colorFilter: const ColorFilter.matrix([
              -0.85, 0.0, 0.0, 0.0, 255.0,
              0.0, -0.85, 0.0, 0.0, 255.0,
              0.0, 0.0, -0.70, 0.0, 255.0,
              0.0, 0.0, 0.0, 1.0, 0.0,
            ]),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _userPosition,
                initialZoom: 16.0,
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
                    // City Park
                    Marker(
                      point: LatLng(_userPosition.latitude + 0.002, _userPosition.longitude - 0.0035),
                      width: 90,
                      height: 25,
                      child: _buildMapLandmark(Icons.park, "City Park", const Color(0xFF00E676)),
                    ),
                    // Central Mall
                    Marker(
                      point: LatLng(_userPosition.latitude - 0.0018, _userPosition.longitude + 0.0035),
                      width: 100,
                      height: 25,
                      child: _buildMapLandmark(Icons.shopping_bag_outlined, "Central Mall", Colors.white70),
                    ),
                    // Metro Station
                    Marker(
                      point: LatLng(_userPosition.latitude - 0.0035, _userPosition.longitude + 0.001),
                      width: 110,
                      height: 25,
                      child: _buildMapLandmark(Icons.train_outlined, "Metro Station", Colors.white70),
                    ),
                    // Concentric Radar Target Pin
                    Marker(
                      point: _userPosition,
                      width: 140,
                      height: 140,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer Radar Circle 1
                              Container(
                                width: 90 + (35 * _pulseController.value),
                                height: 90 + (35 * _pulseController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF2E63).withOpacity(0.2 * (1.0 - _pulseController.value)),
                                  border: Border.all(
                                    color: const Color(0xFFFF2E63).withOpacity(0.4 * (1.0 - _pulseController.value)),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // Outer Radar Circle 2
                              Container(
                                width: 55 + (20 * _pulseController.value),
                                height: 55 + (20 * _pulseController.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF2E63).withOpacity(0.35 * (1.0 - _pulseController.value)),
                                ),
                              ),
                              // Core Target Pin
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF2E63),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF2E63).withOpacity(0.8),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
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
            ),
          ),

          // Top Header Overlay inside map card
          Positioned(
            top: 12,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Live Location Tag
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Live Location",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Sharing with $contactsCount contact${contactsCount == 1 ? '' : 's'}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Updated 5 sec ago pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131622).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Updated 5 sec ago",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.refresh_rounded, color: Colors.white.withOpacity(0.75), size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Compass Button on right
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF131622).withOpacity(0.85),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: const Center(
                child: Icon(Icons.near_me_outlined, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Card 4: "Alerts Sent To" Card ---
  Widget _buildAlertsSentToCard(List<Map<String, dynamic>> contacts) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131622).withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Alerts Sent To + View Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Alerts Sent To",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/contacts'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        color: Color(0xFFFF2E63),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.chevron_right_rounded, color: Color(0xFFFF2E63), size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (contacts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No emergency contacts configured",
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
              ),
            )
          else
            ...contacts.asMap().entries.map((entry) {
              final idx = entry.key;
              final c = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: idx == contacts.length - 1 ? 0 : 12.0),
                child: _buildAlertContactRow(
                  name: c['name']?.toString() ?? 'Contact',
                  phone: c['phone']?.toString() ?? '',
                  relationship: c['relationship']?.toString() ?? (c['isPriority'] == true ? 'Priority' : 'Trusted'),
                  isPriority: c['isPriority'] == true,
                  imageUrl: c['imageUrl']?.toString() ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildAlertContactRow({
    required String name,
    required String phone,
    required String relationship,
    required bool isPriority,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () => _makePhoneCall(phone),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // Avatar with online status
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.18)),
                  image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF131622), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Name & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPriority
                            ? const Color(0xFFFF2E63).withOpacity(0.2)
                            : const Color(0xFF0288D1).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        relationship,
                        style: TextStyle(
                          color: isPriority ? const Color(0xFFFF4D79) : const Color(0xFF29B6F6),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  phone.isNotEmpty ? phone : "Message + Live Location",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Quick Call Action Icon
          GestureDetector(
            onTap: () => _makePhoneCall(phone),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (isPriority ? const Color(0xFFFF2E63) : const Color(0xFF00E676)).withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: (isPriority ? const Color(0xFFFF2E63) : const Color(0xFF00E676)).withOpacity(0.4),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.phone_in_talk_rounded,
                  color: isPriority ? const Color(0xFFFF4D79) : const Color(0xFF00E676),
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Card 5: Quick Calling Dual Cards (Call Police 112 & Call Priority Contact) ---
  Widget _buildQuickCallingCards({
    required String priorityName,
    required String priorityPhone,
  }) {
    return Row(
      children: [
        // Left Card: Call Police 112
        Expanded(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => _makePhoneCall('112'),
              borderRadius: BorderRadius.circular(20),
              splashColor: const Color(0xFF29B6F6).withOpacity(0.2),
              highlightColor: const Color(0xFF29B6F6).withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131622).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0288D1).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.shield_rounded, color: Color(0xFF29B6F6), size: 22),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Call Police",
                            style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 1),
                          Text(
                            "112",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF29B6F6), size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Right Card: Call Priority Contact
        Expanded(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () => _makePhoneCall(priorityPhone),
              borderRadius: BorderRadius.circular(20),
              splashColor: const Color(0xFFFF2E63).withOpacity(0.2),
              highlightColor: const Color(0xFFFF2E63).withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131622).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFF2E63).withOpacity(0.35), width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2E63).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.phone_in_talk_rounded, color: Color(0xFFFF2E63), size: 22),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Call Priority",
                            style: TextStyle(color: Colors.white60, fontSize: 10.5, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            priorityName.isNotEmpty ? priorityName : "Contact",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFFFF2E63), fontSize: 14, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.phone_in_talk_rounded, color: Color(0xFFFF2E63), size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Card 7: "Stop Emergency Mode" Hero Action Button ---
  Widget _buildStopEmergencyButton() {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHoldingStop = true);
        _holdController.forward();
      },
      onTapUp: (_) {
        _holdController.reset();
        setState(() => _isHoldingStop = false);
      },
      onTapCancel: () {
        _holdController.reset();
        setState(() => _isHoldingStop = false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF38101E).withOpacity(0.9),
              const Color(0xFF1E0A12).withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFFF2E63).withOpacity(0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF2E63).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Stop Icon with Hold Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                if (_isHoldingStop)
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      value: _holdController.value,
                      strokeWidth: 3.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFFFF5277),
                        Color(0xFFFF2E63),
                        Color(0xFFB00836),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF2E63).withOpacity(0.7),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.stop_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Stop Emergency Mode",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isHoldingStop ? "Keep holding to cancel alert..." : "Hold for 3 seconds",
                    style: TextStyle(
                      color: _isHoldingStop ? const Color(0xFFFF8FA3) : Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLandmark(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 11),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// Custom Painter for ECG Heartbeat Pulse Line
class _EcgWavePainter extends CustomPainter {
  final Animation<double> animation;

  _EcgWavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF2E63)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height * 0.5;

    path.moveTo(0, midY);
    path.lineTo(size.width * 0.2, midY);
    path.lineTo(size.width * 0.35, midY - 6);
    path.lineTo(size.width * 0.45, midY + 12);
    path.lineTo(size.width * 0.6, midY - 18);
    path.lineTo(size.width * 0.72, midY + 8);
    path.lineTo(size.width * 0.82, midY);
    path.lineTo(size.width, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgWavePainter oldDelegate) => true;
}
