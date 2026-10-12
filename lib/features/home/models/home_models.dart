class MockUser {
  final String name;

  const MockUser({
    required this.name,
  });
}

class SafetyStatus {
  final bool isReady;
  final bool emergencyActive;

  const SafetyStatus({
    this.isReady = true,
    this.emergencyActive = false,
  });
}

class LocationStatus {
  final bool isSharing;
  final bool sharedWithTrustedContacts;

  const LocationStatus({
    this.isSharing = true,
    this.sharedWithTrustedContacts = true,
  });
}

class EmergencyContact {
  final String name;
  final String phone;
  final bool isPriority;

  const EmergencyContact({
    required this.name,
    required this.phone,
    this.isPriority = false,
  });
}
