import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/mock_home_data.dart';
import '../models/home_models.dart';

enum EmergencyState {
  idle,
  activating,
  active,
}

class HomeState {
  final MockUser user;
  final SafetyStatus safetyStatus;
  final LocationStatus locationStatus;
  final EmergencyContact priorityContact;
  final EmergencyState emergencyState;

  const HomeState({
    required this.user,
    required this.safetyStatus,
    required this.locationStatus,
    required this.priorityContact,
    this.emergencyState = EmergencyState.idle,
  });

  HomeState copyWith({
    MockUser? user,
    SafetyStatus? safetyStatus,
    LocationStatus? locationStatus,
    EmergencyContact? priorityContact,
    EmergencyState? emergencyState,
  }) {
    return HomeState(
      user: user ?? this.user,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      locationStatus: locationStatus ?? this.locationStatus,
      priorityContact: priorityContact ?? this.priorityContact,
      emergencyState: emergencyState ?? this.emergencyState,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    return HomeState(
      user: MockHomeData.currentUser,
      safetyStatus: MockHomeData.initialSafetyStatus,
      locationStatus: MockHomeData.currentLocationStatus,
      priorityContact: MockHomeData.priorityContact,
    );
  }

  void setEmergencyState(EmergencyState state) {
    this.state = this.state.copyWith(emergencyState: state);
  }
}

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) => snapshot.data());
});
