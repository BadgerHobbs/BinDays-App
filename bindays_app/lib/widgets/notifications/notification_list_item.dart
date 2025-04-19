// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';

class NotificationListItem extends StatelessWidget {
  final BinCollectionNotification notification;
  final Function(BinCollectionNotification) onUpdateNotification;
  final Function(BinCollectionNotification) onDeleteNotification;

  static const Map<int, String> daysBeforeCollection = {
    0: "On the day of collection",
    1: "1 day before collection",
    2: "2 days before collection",
    3: "3 days before collection",
    4: "4 days before collection",
    5: "5 days before collection",
    6: "6 days before collection",
    7: "7 days before collection",
  };

  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onUpdateNotification,
    required this.onDeleteNotification,
  });

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: notification.time,
    );
    if (pickedTime != null && pickedTime != notification.time) {
      onUpdateNotification(
        BinCollectionNotification(
          id: notification.id,
          enabled: notification.enabled,
          time: pickedTime,
          durationBeforeCollection: notification.durationBeforeCollection,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      // Time (HH:MM) with on tap to select times
      leading: InkWell(
        onTap: () => _selectTime(context),
        child: Text(
          notification.time.format(context),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      // Dropdown for time before collection (days)
      title: DropdownButton<int>(
        isExpanded: true,
        hint: const Text("Days before collection"),
        value: notification.durationBeforeCollection.inDays,
        items: [
          for (int i = 0; i <= 7; i++)
            DropdownMenuItem<int>(
              value: i,
              child: Text(
                daysBeforeCollection[i]!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (value) {
          if (value != null) {
            onUpdateNotification(
              BinCollectionNotification(
                id: notification.id,
                enabled: notification.enabled,
                time: notification.time,
                durationBeforeCollection: Duration(days: value),
              ),
            );
          }
        },
      ),
      trailing: Switch(
        value: notification.enabled,
        onChanged: (value) {
          onUpdateNotification(
            BinCollectionNotification(
              id: notification.id,
              enabled: value,
              time: notification.time,
              durationBeforeCollection: notification.durationBeforeCollection,
            ),
          );
        },
      ),
      onLongPress: () {
        onDeleteNotification(notification);
      },
    );
  }
}
