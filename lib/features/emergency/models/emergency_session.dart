enum EmergencyStatus {
  activating,
  active,
  resolving,
  resolved,
}

class EmergencySession {
  final String id;
  final DateTime startedAt;
  final EmergencyStatus status;

  const EmergencySession({
    required this.id,
    required this.startedAt,
    required this.status,
  });

  EmergencySession copyWith({
    String? id,
    DateTime? startedAt,
    EmergencyStatus? status,
  }) {
    return EmergencySession(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      status: status ?? this.status,
    );
  }
}
