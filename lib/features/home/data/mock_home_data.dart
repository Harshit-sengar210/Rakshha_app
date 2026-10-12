import '../models/home_models.dart';

class MockHomeData {
  static const MockUser currentUser = MockUser(name: "Priya");
  
  static const SafetyStatus initialSafetyStatus = SafetyStatus(
    isReady: true,
    emergencyActive: false,
  );
  
  static const LocationStatus currentLocationStatus = LocationStatus(
    isSharing: true,
    sharedWithTrustedContacts: true,
  );
  
  static const EmergencyContact priorityContact = EmergencyContact(
    name: "Rohan Sharma",
    phone: "+91 98765 43210",
    isPriority: true,
  );
}
