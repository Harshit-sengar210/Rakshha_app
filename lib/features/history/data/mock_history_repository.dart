import '../models/emergency_history_item.dart';

class MockHistoryRepository {
  static final List<EmergencyHistoryItem> initialHistory = [
    EmergencyHistoryItem(
      id: "EMG-1042",
      startedAt: DateTime(2026, 9, 28, 20, 42),
      endedAt: DateTime(2026, 9, 28, 20, 49),
      duration: const Duration(minutes: 7, seconds: 32),
      status: EmergencyHistoryStatus.resolved,
      locationName: "Sector 62, Noida",
      contactsAlerted: 3,
      alerts: [
        EmergencyAlertRecord(
          id: "a1",
          name: "Rohan Sharma",
          relationship: "Priority",
          channel: "WhatsApp",
          status: "Sent",
          time: DateTime(2026, 9, 28, 20, 42),
          isPriority: true,
        ),
        EmergencyAlertRecord(
          id: "a2",
          name: "Mom",
          relationship: "Family",
          channel: "SMS",
          status: "Sent",
          time: DateTime(2026, 9, 28, 20, 42),
        ),
        EmergencyAlertRecord(
          id: "a3",
          name: "Neha Sharma",
          relationship: "Friend",
          channel: "SMS",
          status: "Sent",
          time: DateTime(2026, 9, 28, 20, 43),
        ),
      ],
      locationTimeline: [
        LocationTimelinePoint(
          time: DateTime(2026, 9, 28, 20, 42),
          description: "Location sharing started",
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 28, 20, 43),
          description: "Location updated",
          isLocationUpdate: true,
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 28, 20, 45),
          description: "Location updated",
          isLocationUpdate: true,
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 28, 20, 47),
          description: "Location updated",
          isLocationUpdate: true,
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 28, 20, 49),
          description: "Location sharing stopped",
        ),
      ],
    ),
    EmergencyHistoryItem(
      id: "EMG-1031",
      startedAt: DateTime(2026, 9, 19, 22, 18),
      endedAt: DateTime(2026, 9, 19, 22, 24),
      duration: const Duration(minutes: 6, seconds: 11),
      status: EmergencyHistoryStatus.resolved,
      locationName: "Indirapuram, Ghaziabad",
      contactsAlerted: 2,
      alerts: [
        EmergencyAlertRecord(
          id: "a4",
          name: "Rohan Sharma",
          relationship: "Priority",
          channel: "WhatsApp",
          status: "Sent",
          time: DateTime(2026, 9, 19, 22, 18),
          isPriority: true,
        ),
        EmergencyAlertRecord(
          id: "a5",
          name: "Mom",
          relationship: "Family",
          channel: "SMS",
          status: "Sent",
          time: DateTime(2026, 9, 19, 22, 18),
        ),
      ],
      locationTimeline: [
        LocationTimelinePoint(
          time: DateTime(2026, 9, 19, 22, 18),
          description: "Location sharing started",
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 19, 22, 24),
          description: "Location sharing stopped",
        ),
      ],
    ),
    EmergencyHistoryItem(
      id: "EMG-1017",
      startedAt: DateTime(2026, 9, 7, 18, 32),
      endedAt: DateTime(2026, 9, 7, 18, 34),
      duration: const Duration(minutes: 2, seconds: 5),
      status: EmergencyHistoryStatus.cancelled,
      locationName: "Noida Sector 18",
      contactsAlerted: 1,
      alerts: [
        EmergencyAlertRecord(
          id: "a6",
          name: "Rohan Sharma",
          relationship: "Priority",
          channel: "WhatsApp",
          status: "Sent",
          time: DateTime(2026, 9, 7, 18, 32),
          isPriority: true,
        ),
      ],
      locationTimeline: [
        LocationTimelinePoint(
          time: DateTime(2026, 9, 7, 18, 32),
          description: "Emergency activated",
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 7, 18, 33),
          description: "Alert initiated",
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 7, 18, 34),
          description: "Emergency cancelled",
        ),
        LocationTimelinePoint(
          time: DateTime(2026, 9, 7, 18, 34),
          description: "Location sharing stopped",
        ),
      ],
    ),
  ];
}
