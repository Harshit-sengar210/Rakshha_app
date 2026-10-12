enum LocationShareStatus {
  live,
  updating,
  unavailable,
  reconnecting,
}

class EmergencyLocation {
  final String area;
  final double latitude;
  final double longitude;
  final LocationShareStatus status;
  final DateTime updatedAt;

  const EmergencyLocation({
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.updatedAt,
  });

  EmergencyLocation copyWith({
    String? area,
    double? latitude,
    double? longitude,
    LocationShareStatus? status,
    DateTime? updatedAt,
  }) {
    return EmergencyLocation(
      area: area ?? this.area,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
