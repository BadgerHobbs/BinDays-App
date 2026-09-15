// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';

class NotificationListItem extends StatelessWidget {
  final BinCollectionNotification notification;
  final Function(BinCollectionNotification) onUpdateNotification;
  final Function(BinCollectionNotification) onDeleteNotification;

  static const Map<int, String> daysBeforeCollection = {
    0: "On collection day",
    1: "1 day before",
    2: "2 days before",
    3: "3 days before",
    4: "4 days before",
    5: "5 days before",
    6: "6 days before",
    7: "7 days before",
  };

  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onUpdateNotification,
    required this.onDeleteNotification,
  });

  int get _days => notification.durationBeforeCollection.inDays;

  /// Emit an updated notification, changing only the provided fields.
  void _update({bool? enabled, TimeOfDay? time, int? days}) {
    onUpdateNotification(
      BinCollectionNotification(
        id: notification.id,
        enabled: enabled ?? notification.enabled,
        time: time ?? notification.time,
        durationBeforeCollection:
            days != null
                ? Duration(days: days)
                : notification.durationBeforeCollection,
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: notification.time,
    );
    if (pickedTime != null && pickedTime != notification.time) {
      _update(time: pickedTime);
    }
  }

  Widget _chip(BuildContext context, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  /// Tappable chip for the reminder time.
  Widget _timeChip(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _selectTime(context),
      borderRadius: BorderRadius.circular(20),
      child: _chip(
        context,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule, size: 16),
            const SizedBox(width: 6),
            Text(
              notification.time.format(context),
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Tappable chip for the days-before selection, with a dropdown menu.
  Widget _daysChip(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<int>(
      initialValue: _days,
      tooltip: 'Change when',
      position: PopupMenuPosition.under,
      onSelected: (value) => _update(days: value),
      itemBuilder:
          (context) => [
            for (int i = 0; i <= 7; i++)
              PopupMenuItem<int>(value: i, child: Text(daysBeforeCollection[i]!)),
          ],
      child: _chip(
        context,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              daysBeforeCollection[_days] ?? '',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [_timeChip(context), _daysChip(context)],
              ),
            ),
            const SizedBox(width: 4),
            Switch(
              value: notification.enabled,
              onChanged: (value) => _update(enabled: value),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              tooltip: 'Remove reminder',
              onPressed: () => onDeleteNotification(notification),
            ),
          ],
        ),
      ),
    );
  }
}
