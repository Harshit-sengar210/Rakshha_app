import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriorityContact {
  final String name;
  final String mobile;
  final String relationship;

  PriorityContact({required this.name, required this.mobile, required this.relationship});
}

class TrustedContact {
  final String name;
  final String mobile;
  final String relationship;
  final bool useWhatsApp;
  final bool useSms;

  TrustedContact({
    required this.name,
    required this.mobile,
    this.relationship = 'Friend',
    this.useWhatsApp = true,
    this.useSms = true,
  });

  TrustedContact copyWith({
    String? name,
    String? mobile,
    String? relationship,
    bool? useWhatsApp,
    bool? useSms,
  }) {
    return TrustedContact(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      relationship: relationship ?? this.relationship,
      useWhatsApp: useWhatsApp ?? this.useWhatsApp,
      useSms: useSms ?? this.useSms,
    );
  }
}

class RegistrationData {
  final String fullName;
  final String age;
  final String gender;
  final String address;
  final String mobileNumber;
  final String email;
  final String password;
  final PriorityContact? priorityContact;
  final List<TrustedContact> trustedContacts;
  final String generatedOtp;

  RegistrationData({
    this.fullName = '',
    this.age = '',
    this.gender = '',
    this.address = '',
    this.mobileNumber = '',
    this.email = '',
    this.password = '',
    this.priorityContact,
    this.trustedContacts = const [],
    this.generatedOtp = '',
  });

  RegistrationData copyWith({
    String? fullName,
    String? age,
    String? gender,
    String? address,
    String? mobileNumber,
    String? email,
    String? password,
    PriorityContact? priorityContact,
    List<TrustedContact>? trustedContacts,
    String? generatedOtp,
  }) {
    return RegistrationData(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      priorityContact: priorityContact ?? this.priorityContact,
      trustedContacts: trustedContacts ?? this.trustedContacts,
      generatedOtp: generatedOtp ?? this.generatedOtp,
    );
  }
}

class RegistrationNotifier extends Notifier<RegistrationData> {
  @override
  RegistrationData build() {
    return RegistrationData();
  }

  void updatePersonalInfo({
    String? fullName,
    String? age,
    String? gender,
    String? address,
    String? mobileNumber,
    String? email,
    String? password,
  }) {
    state = state.copyWith(
      fullName: fullName,
      age: age,
      gender: gender,
      address: address,
      mobileNumber: mobileNumber,
      email: email,
      password: password,
    );
  }

  void updatePriorityContact(PriorityContact contact) {
    state = state.copyWith(priorityContact: contact);
  }

  void addTrustedContact(TrustedContact contact) {
    state = state.copyWith(trustedContacts: [...state.trustedContacts, contact]);
  }

  void updateTrustedContact(int index, TrustedContact contact) {
    final updated = List<TrustedContact>.from(state.trustedContacts);
    updated[index] = contact;
    state = state.copyWith(trustedContacts: updated);
  }

  void removeTrustedContact(int index) {
    final updated = List<TrustedContact>.from(state.trustedContacts);
    updated.removeAt(index);
    state = state.copyWith(trustedContacts: updated);
  }

  void clear() {
    state = RegistrationData();
  }

  Future<void> sendWhatsAppOtp() async {
    // Generate real 6-digit OTP
    final String otp = (100000 + Random().nextInt(900000)).toString();
    debugPrint('=== REAL OTP GENERATED: $otp ===');
    state = state.copyWith(generatedOtp: otp);

    const baseUrl = 'https://whatsappapi-1n7u.onrender.com';
    const primaryApiKey = '429683C4C977415CAAFCCE10F7D57E11';
    final candidateApiKeys = ['429683C4C977415CAAFCCE10F7D57E11', 'wapi_live_429683c4c977415caafcce10f7d57e11'];
    final candidateInstances = ['user_4qkhdrjvmfw4yhu3', 'user_rjx6ebs', 'user_kycqvdulwiyuyvsk'];

    String cleanPhone = state.mobileNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.isEmpty) return;
    if (cleanPhone.length == 10) {
      cleanPhone = '91$cleanPhone';
    } else if (cleanPhone.length == 12 && cleanPhone.startsWith('91')) {
      // already fine
    } else if (cleanPhone.startsWith('0')) {
      cleanPhone = '91${cleanPhone.substring(1)}';
    }

    final messageText = "Welcome to Rakshaa! Your verification OTP code is: *$otp*\n\nPlease enter this code in the app to continue your registration.";

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
            debugPrint('WhatsApp OTP sent successfully via $inst');
            sentSuccessfully = true;
            break;
          } else {
            debugPrint('WhatsApp OTP send failed via $inst: ${res.body}');
            if (res.statusCode != 401) {
              break;
            }
          }
        } catch (e) {
          debugPrint('Error sending WhatsApp OTP via $inst: $e');
        }
      }
      if (sentSuccessfully) break;
    }

    // Dynamic recovery: If candidate instances failed, find active open instance on server
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
                  debugPrint('WhatsApp OTP sent successfully via auto-discovered $name');
                  sentSuccessfully = true;
                  break;
                }
              }
            }
          }
          if (sentSuccessfully) break;
        } catch (e) {
          debugPrint('Auto-discovery instance check failed for OTP: $e');
        }
      }
    }

    // Save OTP to Firestore with 5 min expiration
    try {
      await FirebaseFirestore.instance.collection('otps').doc(cleanPhone).set({
        'otp': otp,
        'phone': cleanPhone,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(const Duration(minutes: 5)),
      });
    } catch (e) {
      debugPrint("Error saving OTP to Firestore: $e");
    }
  }
}

final registrationProvider = NotifierProvider<RegistrationNotifier, RegistrationData>(() {
  return RegistrationNotifier();
});
