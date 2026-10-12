class TrustedContact {
  final String id;
  final String name;
  final String relationship;
  final String phone;
  final bool isPriority;
  final bool isWhatsAppEnabled;

  const TrustedContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    this.isPriority = false,
    this.isWhatsAppEnabled = true,
  });

  TrustedContact copyWith({
    String? id,
    String? name,
    String? relationship,
    String? phone,
    bool? isPriority,
    bool? isWhatsAppEnabled,
  }) {
    return TrustedContact(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      isPriority: isPriority ?? this.isPriority,
      isWhatsAppEnabled: isWhatsAppEnabled ?? this.isWhatsAppEnabled,
    );
  }
}
