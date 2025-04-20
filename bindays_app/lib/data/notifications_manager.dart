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
        .replaceFirst(RegExp(r', ([^,]+)$'), r' and $1');

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
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'bin_collection_notifications',
        'Bin Collection Notifications',
        channelDescription: "Notifications for upcoming bin collections.",
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );

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

    final notificationBody = _getNotificationBody(
      binDay,
      binCollectionNotification,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _generateNotificationId(),
      'Upcoming Bin Collections',
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

  /// Schedules all bin collection notifications.
  static Future<void> _scheduleBinCollectionNotifications(
    List<BinCollectionNotification> binCollectionNotifications,
    List<BinDay> binDays,
  ) async {
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
