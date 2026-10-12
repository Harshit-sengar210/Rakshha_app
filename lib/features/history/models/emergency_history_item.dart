enum EmergencyHistoryStatus {
  active,
  resolved,
  cancelled,
  failed,
}

class LocationTimelinePoint {
  final DateTime time;
  final String description;
  final bool isLocationUpdate;

  const LocationTimelinePoint({
    required this.time,
    required this.description,
    this.isLocationUpdate = false,
  });
}

class EmergencyAlertRecord {
  final String id;
  final String name;
  final String relationship;
  final String channel; // e.g. "SMS", "WhatsApp", "Call"
  final String status; // e.g. "Sent", "Delivered", "Failed"
  final DateTime time;
  final bool isPriority;

  const EmergencyAlertRecord({
    required this.id,
    required this.name,
    required this.relationship,
    required this.channel,
    required this.status,
    required this.time,
    this.isPriority = false,
  });
}

class EmergencyHistoryItem {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration duration;
  final EmergencyHistoryStatus status;
  final String locationName;
  final double latitude;
  final double longitude;
  final int contactsAlerted;
  final List<EmergencyAlertRecord> alerts;
  final List<LocationTimelinePoint> locationTimeline;

  const EmergencyHistoryItem({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.duration,
    required this.status,
    required this.locationName,
    this.latitude = 28.6139,
    this.longitude = 77.2090,
    required this.contactsAlerted,
    this.alerts = const [],
    this.locationTimeline = const [],
  });

  EmergencyHistoryItem copyWith({
    String? id,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? duration,
    EmergencyHistoryStatus? status,
    String? locationName,
    double? latitude,
    double? longitude,
    int? contactsAlerted,
    List<EmergencyAlertRecord>? alerts,
    List<LocationTimelinePoint>? locationTimeline,
  }) {
    return EmergencyHistoryItem(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      contactsAlerted: contactsAlerted ?? this.contactsAlerted,
      alerts: alerts ?? this.alerts,
      locationTimeline: locationTimeline ?? this.locationTimeline,
    );
  }
}
