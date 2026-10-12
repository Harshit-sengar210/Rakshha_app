import '../models/trusted_contact.dart';

class MockContactsRepository {
  static final List<TrustedContact> initialContacts = [
    const TrustedContact(
      id: "1",
      name: "Rohan Sharma",
      relationship: "Brother",
      phone: "+91 98765 43210",
      isPriority: true,
    ),
    const TrustedContact(
      id: "2",
      name: "Mom",
      relationship: "Family",
      phone: "+91 98765 43211",
      isPriority: false,
    ),
    const TrustedContact(
      id: "3",
      name: "Neha Sharma",
      relationship: "Friend",
      phone: "+91 98765 43212",
      isPriority: false,
    ),
  ];
}
