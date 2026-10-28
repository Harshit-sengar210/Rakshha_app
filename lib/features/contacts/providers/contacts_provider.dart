import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trusted_contact.dart';

class ContactsState {
  final List<TrustedContact> contacts;

  const ContactsState({
    this.contacts = const [],
  });

  ContactsState copyWith({
    List<TrustedContact>? contacts,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
    );
  }

  TrustedContact? get priorityContact {
    try {
      return contacts.firstWhere((c) => c.isPriority);
    } catch (e) {
      return null;
    }
  }

  List<TrustedContact> get emergencyContacts {
    return contacts.where((c) => !c.isPriority).toList();
  }
}

class ContactsNotifier extends Notifier<ContactsState> {
  @override
  ContactsState build() {
    _loadFromFirestore();
    return const ContactsState(contacts: []);
  }

  void _loadFromFirestore() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        state = const ContactsState(contacts: []);
        return;
      }

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
      if (!doc.exists) return;
      final data = doc.data()!;
      final List<TrustedContact> contacts = [];

      // Load priority contact
      final pc = data['priorityContact'] as Map<String, dynamic>?;
      if (pc != null && (pc['name'] as String? ?? '').isNotEmpty) {
        contacts.add(TrustedContact(
          id: 'priority',
          name: pc['name'] ?? '',
          relationship: pc['relationship'] ?? '',
          phone: pc['phone'] ?? '',
          isPriority: true,
          isWhatsAppEnabled: true,
        ));
      }

      // Load trusted contacts
      final tc = data['trustedContacts'] as List<dynamic>? ?? [];
      for (int i = 0; i < tc.length; i++) {
        final c = tc[i] as Map<String, dynamic>;
        contacts.add(TrustedContact(
          id: 'contact_$i',
          name: c['name'] ?? '',
          relationship: c['relationship'] ?? '',
          phone: c['phone'] ?? '',
          isPriority: false,
          isWhatsAppEnabled: c['hasWhatsApp'] ?? true,
        ));
      }

      state = state.copyWith(contacts: contacts);
    });
    });
  }

  void addContact(TrustedContact contact) {
    if (state.emergencyContacts.length >= 4 && !contact.isPriority) return;
    
    List<TrustedContact> newList = [...state.contacts];
    if (contact.isPriority) {
      newList = newList.map((c) => c.copyWith(isPriority: false)).toList();
    }
    
    final finalContacts = [...newList, contact];
    state = state.copyWith(contacts: finalContacts);
    _syncToFirestore(finalContacts);
  }

  void updateContact(TrustedContact updatedContact) {
    List<TrustedContact> updatedList = state.contacts.map((c) {
      if (c.id == updatedContact.id) return updatedContact;
      return c;
    }).toList();
    
    if (updatedContact.isPriority) {
      updatedList = updatedList.map((c) {
        if (c.id != updatedContact.id && c.isPriority) {
          return c.copyWith(isPriority: false);
        }
        return c;
      }).toList();
    }
    
    state = state.copyWith(contacts: updatedList);
    _syncToFirestore(updatedList);
  }

  void removeContact(String id) {
    final updatedList = state.contacts.where((c) => c.id != id).toList();
    state = state.copyWith(contacts: updatedList);
    _syncToFirestore(updatedList);
  }

  void setPriorityContact(String id) {
    final updatedList = state.contacts.map((c) {
      if (c.id == id) {
        return c.copyWith(isPriority: true);
      } else if (c.isPriority) {
        return c.copyWith(isPriority: false);
      }
      return c;
    }).toList();
    
    state = state.copyWith(contacts: updatedList);
    _syncToFirestore(updatedList);
  }

  Future<void> _syncToFirestore(List<TrustedContact> currentContacts) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    TrustedContact? pc;
    try {
      pc = currentContacts.firstWhere((c) => c.isPriority);
    } catch (_) {}
    
    final tcList = currentContacts.where((c) => !c.isPriority).toList();
    
    Map<String, dynamic>? priorityData;
    if (pc != null) {
      priorityData = {
        'name': pc.name,
        'relationship': pc.relationship,
        'phone': pc.phone,
      };
    }
    
    List<Map<String, dynamic>> trustedData = tcList.map((c) => {
      'name': c.name,
      'relationship': c.relationship,
      'phone': c.phone,
      'hasWhatsApp': c.isWhatsAppEnabled,
    }).toList();

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'priorityContact': priorityData ?? FieldValue.delete(),
        'trustedContacts': trustedData,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error syncing contacts: $e");
    }
  }
}

final contactsProvider = NotifierProvider<ContactsNotifier, ContactsState>(() {
  return ContactsNotifier();
});
