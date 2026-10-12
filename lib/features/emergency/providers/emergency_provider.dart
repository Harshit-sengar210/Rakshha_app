import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/emergency_session.dart';
import '../models/emergency_contact.dart';
import '../models/emergency_location.dart';
import '../../home/providers/home_provider.dart';
import '../../contacts/providers/contacts_provider.dart';

class EmergencyState {
  final EmergencySession? session;
  final EmergencyLocation? location;
  final List<EmergencyAlertContact> contacts;

  const EmergencyState({
    this.session,
    this.location,
    this.contacts = const [],
  });

  EmergencyState copyWith({
    EmergencySession? session,
    EmergencyLocation? location,
    List<EmergencyAlertContact>? contacts,
  }) {
    return EmergencyState(
      session: session ?? this.session,
      location: location ?? this.location,
      contacts: contacts ?? this.contacts,
    );
  }
}

class EmergencyNotifier extends Notifier<EmergencyState> {
  // Track phone numbers that have already received an alert in the current session
  final Set<String> _sentPhoneNumbers = {};
  bool _isDispatching = false;

  @override
  EmergencyState build() {
    return const EmergencyState();
  }

  String _normalizePhone(String rawPhone) {
    String clean = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (clean.isEmpty) return '';
    if (clean.length == 10) {
      clean = '91$clean';
    } else if (clean.startsWith('0')) {
      clean = '91${clean.substring(1)}';
    }
    return clean;
  }

  Future<String> _getAddressFromCoordinates(double lat, double lng) async {
    if (lat == 0 && lng == 0) return "Location pending GPS lock";
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng'),
        headers: {
          'User-Agent': 'RakshaaApp/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['display_name'] != null) {
          return data['display_name'].toString();
        }
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }
    return "Lat: ${lat.toStringAsFixed(5)}, Lon: ${lng.toStringAsFixed(5)}";
  }

  Future<void> _sendWhatsAppMessage({
    required String toPhone,
    required String contactName,
    required double lat,
    required double lng,
    required String address,
  }) async {
    const baseUrl = 'https://whatsappapi-1n7u.onrender.com';
    const apiKey = '429683C4C977415CAAFCCE10F7D57E11';
    final candidateInstances = ['user_rjx6ebs', 'user_kycqvdulwiyuyvsk'];

    final cleanPhone = _normalizePhone(toPhone);
    if (cleanPhone.isEmpty) return;

    // STRICT DEDUPLICATION: Check if this phone number already received the alert
    if (_sentPhoneNumbers.contains(cleanPhone)) {
      debugPrint('[WhatsApp Alert] $cleanPhone already notified in this session. Skipping duplicate.');
      return;
    }

    final userProfile = ref.read(userProfileProvider).value;
    final userName = userProfile?['fullName'] ?? userProfile?['name'] ?? 'Rakshaa User';
    final userPhone = userProfile?['mobileNumber'] ?? userProfile?['phone'] ?? '';
    final timeStr = DateFormat('hh:mm a, dd MMM yyyy').format(DateTime.now());

    final locationLink = (lat != 0 && lng != 0)
        ? "https://www.google.com/maps/search/?api=1&query=$lat,$lng"
        : "https://maps.google.com";

    final coordinatesText = (lat != 0 && lng != 0)
        ? "Lat: $lat, Lon: $lng"
        : "Locating via GPS...";

    final messageText = "🚨 *EMERGENCY SOS ALERT* 🚨\n\n"
        "Hi *$contactName*,\n"
        "*$userName*${userPhone.isNotEmpty ? ' ($userPhone)' : ''} has triggered an Emergency SOS alert and needs immediate help!\n\n"
        "📍 *Full Address*:\n$address\n\n"
        "🌐 *Coordinates*: $coordinatesText\n"
        "🗺️ *Live Google Maps Location*:\n$locationLink\n\n"
        "⏰ *Time*: $timeStr\n\n"
        "⚠️ *Please check on them or contact emergency services immediately!*";
    
    debugPrint('\n=== DISPATCHING WHATSAPP SOS ALERT (SINGLE MSG GUARANTEE) ===');
    debugPrint('To: $cleanPhone ($contactName)');
    debugPrint('============================================================\n');

    bool sentSuccessfully = false;

    for (final inst in candidateInstances) {
      try {
        final res = await http.post(
          Uri.parse('$baseUrl/message/sendText/$inst'),
          headers: {
            'Content-Type': 'application/json',
            'apikey': apiKey,
          },
          body: jsonEncode({
            'number': cleanPhone,
            'text': messageText,
          }),
        ).timeout(const Duration(seconds: 8));

        if (res.statusCode == 200 || res.statusCode == 201) {
          debugPrint('WhatsApp alert sent to $cleanPhone successfully via $inst');
          sentSuccessfully = true;
          break;
        } else {
          debugPrint('WhatsApp alert send failed via $inst (${res.statusCode}): ${res.body}');
        }
      } catch (e) {
        debugPrint('Error sending WhatsApp SOS alert via $inst: $e');
      }
    }

    // Dynamic recovery: If predefined instances failed, fetch current open instance from server
    if (!sentSuccessfully) {
      try {
        final fetchRes = await http.get(
          Uri.parse('$baseUrl/instance/fetchInstances'),
          headers: {'apikey': apiKey},
        ).timeout(const Duration(seconds: 5));

        if (fetchRes.statusCode == 200) {
          final List<dynamic> instances = jsonDecode(fetchRes.body);
          for (final item in instances) {
            final name = item['name']?.toString() ?? '';
            final status = item['connectionStatus']?.toString() ?? '';
            if (status == 'open' && name.isNotEmpty && !candidateInstances.contains(name)) {
              final retryRes = await http.post(
                Uri.parse('$baseUrl/message/sendText/$name'),
                headers: {
                  'Content-Type': 'application/json',
                  'apikey': apiKey,
                },
                body: jsonEncode({
                  'number': cleanPhone,
                  'text': messageText,
                }),
              ).timeout(const Duration(seconds: 8));

              if (retryRes.statusCode == 200 || retryRes.statusCode == 201) {
                debugPrint('WhatsApp alert sent to $cleanPhone via auto-discovered instance $name');
                sentSuccessfully = true;
                break;
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Auto-discovery instance check failed: $e');
      }
    }

    if (sentSuccessfully) {
      _sentPhoneNumbers.add(cleanPhone);
    }
  }

  String? _activeSessionId;

  Future<void> startEmergency({bool forceRestart = false}) async {
    final isNewEmergency = forceRestart || 
        state.session == null || 
        state.session?.status != EmergencyStatus.active;

    if (isNewEmergency) {
      _sentPhoneNumbers.clear();
      _isDispatching = false;
      _activeSessionId = "em_${DateTime.now().millisecondsSinceEpoch}";
    }

    if (_isDispatching) {
      debugPrint('[Emergency] Alert dispatch already in progress. Ignoring concurrent call.');
      return;
    }
    _isDispatching = true;

    try {
      final List<EmergencyAlertContact> realContacts = [];
      final Map<String, String> contactsToNotify = {}; // cleanPhone -> contactName
      final Set<String> registeredPhones = {};

      // 1. Gather contacts from contactsProvider (Contacts Screen)
      final contactsState = ref.read(contactsProvider);
      for (final c in contactsState.contacts) {
        final clean = _normalizePhone(c.phone);
        if (clean.isNotEmpty) {
          final displayName = c.name.isNotEmpty ? c.name : (c.isPriority ? 'Priority Contact' : 'Trusted Contact');
          realContacts.add(
            EmergencyAlertContact(
              id: c.id,
              name: displayName,
              label: c.isPriority ? 'Priority' : (c.relationship.isNotEmpty ? c.relationship : 'Trusted'),
              status: AlertStatus.sending,
              message: "Message + Location",
              updatedAt: DateTime.now(),
            ),
          );
          registeredPhones.add(clean);
          if (c.isWhatsAppEnabled != false) {
            contactsToNotify[clean] = displayName;
          }
        }
      }

      // 2. Always fetch latest contacts directly from Firestore to ensure any newly added contacts are merged
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists) {
            final data = doc.data()!;
            final pData = data['priorityContact'] as Map<String, dynamic>?;
            if (pData != null && (pData['phone'] != null || pData['mobile'] != null)) {
              final pPhone = (pData['phone'] ?? pData['mobile'] ?? '').toString();
              final clean = _normalizePhone(pPhone);
              if (clean.isNotEmpty && !registeredPhones.contains(clean)) {
                final displayName = (pData['name'] ?? 'Priority Contact').toString();
                realContacts.add(
                  EmergencyAlertContact(
                    id: "priority",
                    name: displayName,
                    label: "Priority",
                    status: AlertStatus.sending,
                    message: "Message + Location",
                    updatedAt: DateTime.now(),
                  ),
                );
                registeredPhones.add(clean);
                contactsToNotify[clean] = displayName;
              }
            }

            final tc = data['trustedContacts'] as List<dynamic>?;
            if (tc != null) {
              for (int i = 0; i < tc.length; i++) {
                final c = tc[i] as Map<String, dynamic>;
                final cPhone = (c['phone'] ?? c['mobile'] ?? '').toString();
                final clean = _normalizePhone(cPhone);
                if (clean.isNotEmpty && !registeredPhones.contains(clean)) {
                  final cName = (c['name'] ?? 'Trusted Contact').toString();
                  realContacts.add(
                    EmergencyAlertContact(
                      id: "contact_$i",
                      name: cName,
                      label: c['relationship'] ?? 'Trusted',
                      status: AlertStatus.sending,
                      message: "Message + Location",
                      updatedAt: DateTime.now(),
                    ),
                  );
                  registeredPhones.add(clean);
                  if (c['hasWhatsApp'] != false) {
                    contactsToNotify[clean] = cName;
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Error fetching direct contacts from firestore: $e");
      }
        

      // Get current live position or cached position
      double lat = state.location?.latitude ?? 0.0;
      double lng = state.location?.longitude ?? 0.0;
      String address = state.location?.area ?? "Acquiring live location...";

      // If lat/lng was 0, attempt immediate GPS fetch
      if (lat == 0 || lng == 0) {
        try {
          Position? pos;
          try {
            pos = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 3),
              ),
            );
          } catch (_) {
            pos = await Geolocator.getLastKnownPosition();
          }

          if (pos != null && pos.latitude != 0 && pos.longitude != 0) {
            lat = pos.latitude;
            lng = pos.longitude;
            address = await _getAddressFromCoordinates(lat, lng);
          }
        } catch (e) {
          debugPrint("Error fetching GPS in startEmergency: $e");
        }
      } else if (address.contains("Locat") || address.contains("Acquir")) {
        address = await _getAddressFromCoordinates(lat, lng);
      }

      state = state.copyWith(
        session: EmergencySession(
          id: _activeSessionId ?? state.session?.id ?? "em_${DateTime.now().millisecondsSinceEpoch}",
          startedAt: state.session?.startedAt ?? DateTime.now(),
          status: EmergencyStatus.active,
        ),
        location: EmergencyLocation(
          area: address,
          latitude: lat,
          longitude: lng,
          status: LocationShareStatus.live,
          updatedAt: DateTime.now(),
        ),
        contacts: realContacts,
      );

      // Simulate sending alerts UI animation
      for (int i = 0; i < realContacts.length; i++) {
        Future.delayed(Duration(milliseconds: 1000 + (i * 200)), () {
          updateContactStatus(realContacts[i].id, AlertStatus.sent);
        });
      }

      // Dispatch EXACTLY ONE WhatsApp message to each distinct contact phone number
      debugPrint('[Emergency] Dispatching WhatsApp messages to ${contactsToNotify.length} distinct contacts');
      contactsToNotify.forEach((phone, name) {
        _sendWhatsAppMessage(
          toPhone: phone,
          contactName: name,
          lat: lat,
          lng: lng,
          address: address,
        );
      });

      // SYNC TO FIRESTORE
      _syncEmergencyToFirestore("active", realContacts.length, lat, lng, address);
    } finally {
      _isDispatching = false;
    }
  }

  Future<void> _syncEmergencyToFirestore(String status, int notifiedCount, [double? lat, double? lng, String? address]) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docId = state.session?.id;
        if (docId != null) {
          final userProfile = ref.read(userProfileProvider).value;
          await FirebaseFirestore.instance.collection('emergencies').doc(docId).set({
            'userId': user.uid,
            'userName': userProfile?['fullName'] ?? 'Unknown User',
            'userPhone': userProfile?['mobileNumber'] ?? '',
            'status': status,
            'startedAt': state.session?.startedAt ?? DateTime.now(),
            'resolvedAt': status == 'resolved' ? DateTime.now() : null,
            'notifiedCount': notifiedCount,
            'latitude': lat ?? state.location?.latitude,
            'longitude': lng ?? state.location?.longitude,
            'address': address ?? state.location?.area,
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      debugPrint("Error syncing emergency to firestore: $e");
    }
  }

  void updateContactStatus(String id, AlertStatus newStatus) {
    if (state.contacts.isEmpty) return;
    
    final updatedContacts = state.contacts.map((contact) {
      if (contact.id == id) {
        return contact.copyWith(status: newStatus, updatedAt: DateTime.now());
      }
      return contact;
    }).toList();
    
    state = state.copyWith(contacts: updatedContacts);
  }

  void updateLocationTimestamp() {
    if (state.location != null) {
      state = state.copyWith(
        location: state.location!.copyWith(updatedAt: DateTime.now()),
      );
    }
  }

  void resolveEmergency() {
    _sentPhoneNumbers.clear();
    _isDispatching = false;
    _activeSessionId = null;

    if (state.session != null) {
      state = state.copyWith(
        session: state.session!.copyWith(status: EmergencyStatus.resolved),
      );
      // SYNC TO FIRESTORE
      _syncEmergencyToFirestore("resolved", state.contacts.length);
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    if (latitude == 0 && longitude == 0) return;

    String currentArea = state.location?.area ?? "Acquiring live location...";
    // If area is not resolved yet or default placeholder, resolve it
    if (latitude != 0 && longitude != 0 && (currentArea.contains("Locat") || currentArea.contains("Acquir") || currentArea.startsWith("Lat:"))) {
      currentArea = await _getAddressFromCoordinates(latitude, longitude);
    }

    state = state.copyWith(
      location: EmergencyLocation(
        area: currentArea,
        latitude: latitude,
        longitude: longitude,
        status: state.location?.status ?? LocationShareStatus.live,
        updatedAt: DateTime.now(),
      )
    );
    
    // Sync Location update to active emergency (Do NOT re-send WhatsApp messages!)
    if (state.session?.status == EmergencyStatus.active) {
      _syncEmergencyToFirestore("active", state.contacts.length, latitude, longitude, currentArea);
    }
  }
}

final emergencyProvider = NotifierProvider<EmergencyNotifier, EmergencyState>(() {
  return EmergencyNotifier();
});
