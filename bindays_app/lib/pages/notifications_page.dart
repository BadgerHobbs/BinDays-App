// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/notifications/notification_list_item.dart';
import 'package:bindays_app/widgets/primary_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    globalStateNotifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    globalStateNotifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _addNotification() {
    final newNotification = BinCollectionNotification(
      enabled: true,
      time: TimeOfDay.now(),
      durationBeforeCollection: const Duration(days: 1),
    );

    globalStateNotifier.setNotifications([
      ...globalStateNotifier.notifications ?? [],
      newNotification,
    ]);
  }

  void _updateNotification(BinCollectionNotification notification) {
    globalStateNotifier.setNotifications(
      globalStateNotifier.notifications!
          .map(
            (element) => element.id == notification.id ? notification : element,
          )
          .toList(),
    );
  }

  void _deleteNotification(BinCollectionNotification notification) {
    globalStateNotifier.setNotifications(
      globalStateNotifier.notifications!
          .where((element) => element.id != notification.id)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = globalStateNotifier.notifications ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: SafeBasePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Get reminded before your bin collections. Reminders apply to '
                'all of your saved addresses.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationListItem(
                    notification: notifications[index],
                    onUpdateNotification: _updateNotification,
                    onDeleteNotification: _deleteNotification,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Add Reminder', onPressed: _addNotification),
          ],
        ),
      ),
    );
  }
}
