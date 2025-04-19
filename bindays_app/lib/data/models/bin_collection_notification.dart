// External Imports
import 'package:flutter/material.dart';

/// Represents a notification for a bin collection.
class BinCollectionNotification {
  /// The unique identifier of the notification.
  late int id;

  /// Whether the notification is enabled.
  bool enabled;

  /// The time of day the notification should be sent.
  TimeOfDay time;

  /// The duration before the bin collection that the notification should be sent.
  ///
  /// For example, if the duration is 1 day, and the bin collection is on
  /// Wednesday, the notification will be sent on Tuesday at the specified
  /// [time].
  Duration durationBeforeCollection;

  BinCollectionNotification({
    int? id,
    required this.enabled,
    required this.time,
    required this.durationBeforeCollection,
  }) {
    this.id = id ?? DateTime.now().millisecondsSinceEpoch.hashCode;
  }

  /// Converts this [BinCollectionNotification] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enabled': enabled,
      'time': {'hour': time.hour, 'minute': time.minute},
      'durationBeforeCollection': durationBeforeCollection.inDays,
    };
  }

  /// Creates a [BinCollectionNotification] from a JSON map.
  factory BinCollectionNotification.fromJson(Map<String, dynamic> json) {
    return BinCollectionNotification(
      id: json['id'],
      enabled: json['enabled'],
      time: TimeOfDay(
        hour: json['time']['hour'],
        minute: json['time']['minute'],
      ),
      durationBeforeCollection: Duration(
        days: json['durationBeforeCollection'],
      ),
    );
  }
}
