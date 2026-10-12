import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String fullName;
  final String mobileNumber;
  final String email;
  final String address;
  final bool isMobileVerified;
  final String priorityContactName;
  final int trustedContactsCount;
  final int emergencyHistoryCount;

  UserProfile({
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.isMobileVerified,
    required this.priorityContactName,
    required this.trustedContactsCount,
    required this.emergencyHistoryCount,
  });

  UserProfile copyWith({
    String? fullName,
    String? mobileNumber,
    String? email,
    String? address,
    bool? isMobileVerified,
    String? priorityContactName,
    int? trustedContactsCount,
    int? emergencyHistoryCount,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      isMobileVerified: isMobileVerified ?? this.isMobileVerified,
      priorityContactName: priorityContactName ?? this.priorityContactName,
      trustedContactsCount: trustedContactsCount ?? this.trustedContactsCount,
      emergencyHistoryCount: emergencyHistoryCount ?? this.emergencyHistoryCount,
    );
  }

  factory UserProfile.empty() => UserProfile(
    fullName: '',
    mobileNumber: '',
    email: '',
    address: '',
    isMobileVerified: false,
    priorityContactName: '',
    trustedContactsCount: 0,
    emergencyHistoryCount: 0,
  );
}

class ProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    _loadFromFirestore();
    return UserProfile.empty();
  }

  void _loadFromFirestore() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        state = UserProfile.empty();
        return;
      }

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
      if (!doc.exists) return;
      final data = doc.data()!;

      final pc = data['priorityContact'] as Map<String, dynamic>?;
      final pcName = pc != null && (pc['name'] as String? ?? '').isNotEmpty
          ? '${pc['name']} · ${pc['relationship'] ?? ''}'
          : '';

      final tc = data['trustedContacts'] as List<dynamic>? ?? [];

      state = UserProfile(
        fullName: data['fullName'] ?? '',
        mobileNumber: data['mobileNumber'] ?? '',
        email: data['email'] ?? user.email ?? '',
        address: data['address'] ?? '',
        isMobileVerified: true,
        priorityContactName: pcName,
        trustedContactsCount: tc.length,
        emergencyHistoryCount: state.emergencyHistoryCount,
      );
    });
    });
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfile>(() {
  return ProfileNotifier();
});
