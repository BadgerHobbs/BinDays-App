// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/notifications/notification_list_item.dart';
import 'package:bindays_app/widgets/primary_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<BinCollectionNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  Future<void> _getNotifications() async {
    // Load notifications from storage
    // Update state with loaded notifications
    final testNoficiations = [
      BinCollectionNotification(
        enabled: true,
        time: const TimeOfDay(hour: 18, minute: 00),
        durationBeforeCollection: const Duration(days: 1),
      ),
      BinCollectionNotification(
        enabled: true,
        time: const TimeOfDay(hour: 18, minute: 00),
        durationBeforeCollection: const Duration(days: 2),
      ),
      BinCollectionNotification(
        enabled: true,
        time: const TimeOfDay(hour: 18, minute: 00),
        durationBeforeCollection: const Duration(days: 3),
      ),
      BinCollectionNotification(
        enabled: true,
        time: const TimeOfDay(hour: 18, minute: 00),
        durationBeforeCollection: const Duration(days: 4),
      ),
    ];
    setState(() => notifications = testNoficiations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeBasePage(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {},
              ),
            ),
            Text(
              "Add and manage notifications for future bin collections, long press to delete notifications.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationListItem(
                    notification: notifications[index],
                    onUpdateNotification: (updatedNotification) {
                      setState(() {
                        notifications[index] = updatedNotification;
                      });
                    },
                    onDeleteNotification: (notificationToDelete) {
                      setState(() {
                        notifications.remove(notificationToDelete);
                      });
                    },
                  );
                },
              ),
            ),
            PrimaryButton(
              text: "Return",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
