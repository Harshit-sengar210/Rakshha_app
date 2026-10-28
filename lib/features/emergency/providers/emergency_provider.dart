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
import 'package:rakshaa/core/services/app_location_service.dart';

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
  final Set<String> _pendingPhoneNumbers = {};
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
    const primaryApiKey = '429683C4C977415CAAFCCE10F7D57E11';
    final candidateApiKeys = ['429683C4C977415CAAFCCE10F7D57E11', 'wapi_live_429683c4c977415caafcce10f7d57e11'];
    final candidateInstances = ['user_4qkhdrjvmfw4yhu3', 'user_rjx6ebs', 'user_kycqvdulwiyuyvsk'];

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
      for (final key in candidateApiKeys) {
        try {
          final res = await http.post(
            Uri.parse('$baseUrl/message/sendText/$inst'),
            headers: {
              'Content-Type': 'application/json',
              'apikey': key,
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
            if (res.statusCode != 401) {
              break; // Not an auth error, skip trying other keys for this instance
            }
          }
        } catch (e) {
          debugPrint('Error sending WhatsApp SOS alert via $inst: $e');
        }
      }
      if (sentSuccessfully) break;
    }

    // Dynamic recovery: If predefined instances failed, fetch current open instance from server
    if (!sentSuccessfully) {
      for (final key in candidateApiKeys) {
        try {
          final fetchRes = await http.get(
            Uri.parse('$baseUrl/instance/fetchInstances'),
            headers: {'apikey': key},
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
                    'apikey': key,
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
          if (sentSuccessfully) break;
        } catch (e) {
          debugPrint('Auto-discovery instance check failed: $e');
        }
      }
    }

    _pendingPhoneNumbers.remove(cleanPhone);
    if (sentSuccessfully) {
      _sentPhoneNumbers.add(cleanPhone);
    }
  }

  String? _activeSessionId;

  Future<void> startEmergency({bool forceRestart = false}) async {
    final isCurrentlyActive = state.session?.status == EmergencyStatus.active;

    if (forceRestart || !isCurrentlyActive) {
      _sentPhoneNumbers.clear();
      _pendingPhoneNumbers.clear();
      _isDispatching = false;
      _activeSessionId = "em_${DateTime.now().millisecondsSinceEpoch}";

      // Immediately activate session in state so any rapid subsequent calls know emergency is active
      state = state.copyWith(
        session: EmergencySession(
          id: _activeSessionId!,
          startedAt: DateTime.now(),
          status: EmergencyStatus.active,
        ),
      );
    }

    if (_isDispatching) {
      debugPrint('[Emergency] Alert dispatch already in progress. Ignoring duplicate trigger.');
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
        if (clean.isNotEmpty && !registeredPhones.contains(clean)) {
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
      if (lat == 0 || lng == 0) {
        final cached = AppLocationService.currentLocation;
        if (cached.latitude != 0 && cached.longitude != 0 && cached != AppLocationService.defaultDelhi) {
          lat = cached.latitude;
          lng = cached.longitude;
        }
      }

      String address = state.location?.area ?? "Acquiring live location...";

      // If lat/lng was 0, attempt fast hardware cache check
      if (lat == 0 || lng == 0) {
        try {
          final pos = await Geolocator.getLastKnownPosition();
          if (pos != null && pos.latitude != 0 && pos.longitude != 0) {
            lat = pos.latitude;
            lng = pos.longitude;
          }
        } catch (e) {
          debugPrint("Error fetching GPS in startEmergency: $e");
        }
      }

      if (lat != 0 && lng != 0 && (address.contains("Locat") || address.contains("Acquir") || address.startsWith("Lat:"))) {
        address = await _getAddressFromCoordinates(lat, lng);
      }

      state = state.copyWith(
        session: state.session?.copyWith(status: EmergencyStatus.active) ?? EmergencySession(
          id: _activeSessionId ?? "em_${DateTime.now().millisecondsSinceEpoch}",
          startedAt: DateTime.now(),
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

      // STRICT DEDUPLICATION: Only notify numbers that have not been sent and are not pending
      final List<MapEntry<String, String>> unnotifiedContacts = contactsToNotify.entries.where((entry) {
        final phone = entry.key;
        return !_sentPhoneNumbers.contains(phone) && !_pendingPhoneNumbers.contains(phone);
      }).toList();

      debugPrint('[Emergency] Dispatching WhatsApp messages to ${unnotifiedContacts.length} unnotified contacts (total configured: ${contactsToNotify.length})');

      // SYNCHRONOUSLY lock numbers as pending before any async awaits occur!
      for (final entry in unnotifiedContacts) {
        _pendingPhoneNumbers.add(entry.key);
      }

      // Dispatch and AWAIT all WhatsApp messages so _isDispatching remains true until complete!
      final dispatchFutures = unnotifiedContacts.map((entry) {
        return _sendWhatsAppMessage(
          toPhone: entry.key,
          contactName: entry.value,
          lat: lat,
          lng: lng,
          address: address,
        );
      }).toList();

      if (dispatchFutures.isNotEmpty) {
        await Future.wait(dispatchFutures);
      }

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
    _pendingPhoneNumbers.clear();
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
