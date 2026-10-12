import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emergency_history_item.dart';
import '../data/mock_history_repository.dart';
import 'package:rakshaa/core/services/app_location_service.dart';

class HistoryState {
  final List<EmergencyHistoryItem> records;
  final EmergencyHistoryStatus? filter;

  const HistoryState({
    this.records = const [],
    this.filter,
  });

  HistoryState copyWith({
    List<EmergencyHistoryItem>? records,
    EmergencyHistoryStatus? filter,
    bool clearFilter = false,
  }) {
    return HistoryState(
      records: records ?? this.records,
      filter: clearFilter ? null : (filter ?? this.filter),
    );
  }

  List<EmergencyHistoryItem> get filteredRecords {
    if (filter == null) return records;
    return records.where((r) => r.status == filter).toList();
  }
}

class HistoryNotifier extends Notifier<HistoryState> {
  @override
  HistoryState build() {
    _fetchHistory();
    return const HistoryState(
      records: [],
    );
  }

  void _fetchHistory() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    FirebaseFirestore.instance
        .collection('emergencies')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      final List<EmergencyHistoryItem> items = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final startedAt = (data['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
        final resolvedAt = (data['resolvedAt'] as Timestamp?)?.toDate();
        final statusStr = (data['status'] as String?)?.toLowerCase() ?? 'resolved';
        
        EmergencyHistoryStatus status;
        if (statusStr == 'active') {
          status = EmergencyHistoryStatus.active;
        } else if (statusStr == 'cancelled') {
          status = EmergencyHistoryStatus.cancelled;
        } else {
          status = EmergencyHistoryStatus.resolved;
        }

        final defaultLoc = AppLocationService.currentLocation;
        final double lat = (data['latitude'] as num?)?.toDouble() ?? defaultLoc.latitude;
        final double lng = (data['longitude'] as num?)?.toDouble() ?? defaultLoc.longitude;
        final String address = (data['address'] as String?) ??
            (data['locationName'] as String?) ??
            (data['latitude'] != null ? "Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}" : "Location recorded");

        final int notified = (data['notifiedCount'] as num?)?.toInt() ?? 0;
        final Duration duration = resolvedAt != null
            ? resolvedAt.difference(startedAt)
            : DateTime.now().difference(startedAt);

        items.add(EmergencyHistoryItem(
          id: doc.id,
          startedAt: startedAt,
          endedAt: resolvedAt,
          duration: duration,
          status: status,
          locationName: address,
          latitude: lat,
          longitude: lng,
          contactsAlerted: notified,
          alerts: [],
          locationTimeline: [],
        ));
      }
      // Sort newest first
      items.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      state = state.copyWith(records: items);
    });
  }

  void setFilter(EmergencyHistoryStatus? filter) {
    state = state.copyWith(filter: filter, clearFilter: filter == null);
  }

  Future<void> deleteRecord(String id) async {
    try {
      await FirebaseFirestore.instance.collection('emergencies').doc(id).delete();
    } catch (_) {}
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(() {
  return HistoryNotifier();
});
