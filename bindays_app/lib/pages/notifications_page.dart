// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/notifications/notification_list_item.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    globalStateNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _addNotification() {
    final newNotification = BinCollectionNotification(
      enabled: true,
      time: TimeOfDay.now(),
      durationBeforeCollection: const Duration(days: 1),
    );

    setState(() {
      globalStateNotifier.setNotifications([
        ...globalStateNotifier.notifications ?? [],
        newNotification,
      ]);
    });
  }

  void _updateNotification(BinCollectionNotification notification) {
    setState(() {
      globalStateNotifier.setNotifications(
        globalStateNotifier.notifications!
            .map(
              (element) =>
                  element.id == notification.id ? notification : element,
            )
            .toList(),
      );
    });
  }

  void _deleteNotification(BinCollectionNotification notification) {
    setState(() {
      globalStateNotifier.setNotifications(
        globalStateNotifier.notifications!
            .where((element) => element.id != notification.id)
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = globalStateNotifier.notifications ?? [];

    return Scaffold(
      body: SafeBasePage(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_circle_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: _addNotification,
              ),
            ),
            const Text(
              "Add and manage notifications for future bin collections, long press to delete notifications.",
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationListItem(
                  notification: notifications[index],
                  onUpdateNotification: _updateNotification,
                  onDeleteNotification: _deleteNotification,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
