// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';

/// Manages the scheduling and handling of local notifications.
class NotificationsManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'bin_collection_notifications',
      'Bin Collection Notifications',
      channelDescription: "Notifications for upcoming bin collections.",
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    ),
    iOS: DarwinNotificationDetails(),
  );

  static Future<void> init() async {
    // Android initialisation settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('notification_icon');

    // Ios initialisation settings
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    // Combine Android and ios settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    // Intialize timezones
    tz.initializeTimeZones();

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _requestPermissions();
  }

  /// Request device permissions
  static void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Generates a unique notification id.
  static int _generateNotificationId() {
    return UniqueKey().hashCode;
  }

  /// Gets the notification body for the given bin day and notification.
  static String _getNotificationBody(
    BinDay binDay,
    BinCollectionNotification binCollectionNotification,
  ) {
    // Join bin names together by ',' except the last one which is 'and'
    String binsToCollect = binDay.bins
        .map((bin) => bin.name)
        .join(', ')
        .replaceFirst(RegExp(r', ([^,]+)$'), ' and ${binDay.bins.last.name}');

    // Timeframe (today, tomorrow, in N days)
    final daysBefore =
        binCollectionNotification.durationBeforeCollection.inDays;
    final timeframe =
        daysBefore == 0
            ? "today"
            : daysBefore == 1
            ? "tomorrow"
            : "in $daysBefore days";

    final plurality = binDay.bins.length == 1 ? "" : "s";

    return "Collection of your $binsToCollect bin$plurality is $timeframe.";
  }

  /// Schedules a bin collection notification.
  static Future<void> _scheduleBinCollectionNotification(
    BinDay binDay,
    BinCollectionNotification binCollectionNotification,
  ) async {
    final notificationDate = binDay.date.subtract(
      binCollectionNotification.durationBeforeCollection,
    );
    final notificationDateTime = DateTime(
      notificationDate.year,
      notificationDate.month,
      notificationDate.day,
      binCollectionNotification.time.hour,
      binCollectionNotification.time.minute,
    );

    // Skip creating notification if in the past
    if (notificationDateTime.isBefore(DateTime.now())) {
      return;
    }

    final notificationBody = _getNotificationBody(
      binDay,
      binCollectionNotification,
    );
    final plurality = binDay.bins.length == 1 ? "" : "s";

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _generateNotificationId(),
      'Upcoming Bin Collection$plurality',
      notificationBody,
      tz.TZDateTime.from(notificationDateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Cancels all unsent notifications.
  static Future<void> _cancelUnSentNotifications() async {
    final pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final activeNotifications =
        await flutterLocalNotificationsPlugin.getActiveNotifications();

    final notificationsToCancel = pendingNotifications.where(
      (pendingNotification) =>
          !activeNotifications.any(
            (activeNotification) =>
                activeNotification.id == pendingNotification.id,
          ),
    );

    for (final notification in notificationsToCancel) {
      await flutterLocalNotificationsPlugin.cancel(notification.id);
    }
  }

  /// Schedules a notification that there are no more notifications and the user needs to refresh manually.
  /// This notification is scheduled for the day after the last bin day.
  static Future<void> _scheduleNoMoreNotificationsReminder(
    BinDay lastBinDay,
    BinCollectionNotification binCollectionNotification,
  ) async {
    final notificationDateTime = DateTime(
      lastBinDay.date.year,
      lastBinDay.date.month,
      lastBinDay.date.day,
      // Use the notification time
      binCollectionNotification.time.hour,
      binCollectionNotification.time.minute,
    );
    final notificationDate = notificationDateTime.add(const Duration(days: 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _generateNotificationId(),
      'Scheduled Notifications Reminder',
      'There are no more scheduled bin collection notifications. Open the app to refresh.',
      tz.TZDateTime.from(notificationDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedules all bin collection notifications.
  static Future<void> _scheduleBinCollectionNotifications(
    List<BinCollectionNotification> binCollectionNotifications,
    List<BinDay> binDays,
  ) async {
    // Cancel all unsent notifications
    await _cancelUnSentNotifications();

    for (final binCollectionNotification in binCollectionNotifications) {
      if (!binCollectionNotification.enabled) {
        continue;
      }

      for (final binDay in binDays) {
        await _scheduleBinCollectionNotification(
          binDay,
          binCollectionNotification,
        );
      }
    }

    if (binCollectionNotifications.isNotEmpty && binDays.isNotEmpty) {
      // Get the last bin day for the no more notifications reminder
      final lastBinDay = binDays.reduce(
        (a, b) => a.date.isAfter(b.date) ? a : b,
      );

      // Schedule no more notifications reminder for first configured notification
      await _scheduleNoMoreNotificationsReminder(
        lastBinDay,
        binCollectionNotifications.first,
      );
    }
  }

  /// Schedules all bin collection notifications from global state.
  static Future<void> scheduleBinCollectionNotifications() async {
    // Fetch bin collections and notifications from global state
    final binDays = globalStateNotifier.binDays ?? [];
    final binCollectionNotifications = globalStateNotifier.notifications ?? [];

    await _scheduleBinCollectionNotifications(
      binCollectionNotifications,
      binDays,
    );
  }
}
