import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class LocationPermissionService {
  /// Check and prompt user for all necessary location permissions (Foreground & Background)
  static Future<bool> requestAllLocationPermissions({BuildContext? context}) async {
    try {
      // 1. Check if location services (GPS hardware) are enabled
      bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        // Try triggering native service prompt via location package
        final loc.Location locationPlugin = loc.Location();
        isLocationServiceEnabled = await locationPlugin.requestService();
        
        if (!isLocationServiceEnabled) {
          if (context != null && context.mounted) {
            _showEnableGpsDialog(context);
          }
          return false;
        }
      }

      // 2. Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // 3. Request if denied
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context != null && context.mounted) {
            _showPermissionDeniedSnackBar(context);
          }
          return false;
        }
      }

      // 4. Handle permanently denied
      if (permission == LocationPermission.deniedForever) {
        if (context != null && context.mounted) {
          _showPermanentlyDeniedDialog(context);
        }
        return false;
      }

      // 5. Permission granted (whileInUse or always)
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      debugPrint("LocationPermissionService error: $e");
      return false;
    }
  }

  /// Check without triggering dialogs
  static Future<bool> hasLocationPermission() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return false;

      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (_) {
      return false;
    }
  }

  static void _showEnableGpsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131622),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Row(
          children: const [
            Icon(Icons.location_off_rounded, color: Color(0xFFFF2E63), size: 24),
            SizedBox(width: 10),
            Text(
              "Enable GPS Location",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ],
        ),
        content: Text(
          "Rakshaa requires device GPS to track your real-time location and dispatch accurate coordinates to emergency contacts.",
          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2E63),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await Geolocator.openLocationSettings();
            },
            child: const Text("Open GPS Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static void _showPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131622),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Row(
          children: const [
            Icon(Icons.security_rounded, color: Color(0xFFFF2E63), size: 24),
            SizedBox(width: 10),
            Text(
              "Location Permission",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
            ),
          ],
        ),
        content: Text(
          "Location access was permanently disabled. Please allow location permissions in App Settings so Rakshaa can safeguard you in emergencies.",
          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Not Now", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2E63),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await Geolocator.openAppSettings();
            },
            child: const Text("Open App Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  static void _showPermissionDeniedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF131622),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFFFF2E63).withOpacity(0.3)),
        ),
        content: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFF2E63), size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Location permission is needed for emergency SOS tracking.",
                style: TextStyle(color: Colors.white, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
