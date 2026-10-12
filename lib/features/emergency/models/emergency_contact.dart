enum AlertStatus {
  sending,
  sent,
  delivered,
  failed,
  retrying,
}

class EmergencyAlertContact {
  final String id;
  final String name;
  final String label;
  final AlertStatus status;
  final String message;
  final DateTime updatedAt;

  const EmergencyAlertContact({
    required this.id,
    required this.name,
    required this.label,
    required this.status,
    required this.message,
    required this.updatedAt,
  });

  EmergencyAlertContact copyWith({
    String? id,
    String? name,
    String? label,
    AlertStatus? status,
    String? message,
    DateTime? updatedAt,
  }) {
    return EmergencyAlertContact(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      status: status ?? this.status,
      message: message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
