// External Imports
import 'dart:math';
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/data/models/cancellation_token.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';

/// Manages the scheduling and handling of local notifications.
class NotificationsManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// iOS limits scheduled notifications to 64. Reserve 1 slot for the
  /// "no more notifications" reminder.
  static const int _maxBinCollectionNotifications = 63;

  /// Token for the currently active scheduling operation. Cancelled when
  /// a new scheduling call supersedes it.
  static CancellationToken? _activeCancellationToken;

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

    // Initialize timezones
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

  static final _random = Random();

  /// Generates a random notification ID.
  static int _generateNotificationId() => _random.nextInt(1 << 31);

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

  /// Schedules all bin collection notifications.
  ///
  /// Checks [cancellationToken] after each async gap; if cancelled, stops
  /// early and lets the newer call take over.
  static Future<void> _scheduleBinCollectionNotifications(
    List<BinCollectionNotification> binCollectionNotifications,
    List<BinDay> binDays,
    CancellationToken cancellationToken,
  ) async {
    // Cancel only pending (not yet delivered) notifications, preserving
    // any active notifications already showing in the notification tray.
    final pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await Future.wait(
      pendingNotifications.map(
        (n) => flutterLocalNotificationsPlugin.cancel(n.id),
      ),
    );
    if (cancellationToken.isCancelled) return;

    final now = DateTime.now();
    final enabledNotifications =
        binCollectionNotifications.where((n) => n.enabled).toList();

    if (enabledNotifications.isEmpty || binDays.isEmpty) {
      return;
    }

    // Build all candidate (dateTime, binDay, notification) tuples,
    // filtering out past notifications, then sort by date ascending.
    final candidates =
        <
          ({
            DateTime dateTime,
            BinDay binDay,
            BinCollectionNotification notification,
          })
        >[];

    for (final binCollectionNotification in enabledNotifications) {
      for (final binDay in binDays) {
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

        if (notificationDateTime.isAfter(now)) {
          candidates.add((
            dateTime: notificationDateTime,
            binDay: binDay,
            notification: binCollectionNotification,
          ));
        }
      }
    }

    // Sort by date ascending so earliest notifications are scheduled first
    candidates.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Truncate to the iOS limit, reserving 1 slot for the reminder
    final toSchedule = candidates.take(_maxBinCollectionNotifications).toList();

    for (final candidate in toSchedule) {
      if (cancellationToken.isCancelled) return;

      final notificationBody = _getNotificationBody(
        candidate.binDay,
        candidate.notification,
      );
      final plurality = candidate.binDay.bins.length == 1 ? "" : "s";

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _generateNotificationId(),
        'Upcoming Bin Collection$plurality',
        notificationBody,
        tz.TZDateTime.from(candidate.dateTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    if (cancellationToken.isCancelled) return;

    // Schedule reminder for the day after the last *scheduled* notification,
    // not the last bin day, so the user is prompted to refresh sooner when
    // the notification limit is reached.
    final lastScheduledBinDay = toSchedule.last.binDay;
    final reminderNotification = enabledNotifications.first;
    final reminderDateTime = DateTime(
      lastScheduledBinDay.date.year,
      lastScheduledBinDay.date.month,
      lastScheduledBinDay.date.day,
      reminderNotification.time.hour,
      reminderNotification.time.minute,
    ).add(const Duration(days: 1));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _generateNotificationId(),
      'Scheduled Notifications Reminder',
      'There are no more scheduled bin collection notifications. Open the app to refresh.',
      tz.TZDateTime.from(reminderDateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedules all bin collection notifications from global state.
  ///
  /// If a scheduling operation is already in progress, it is cancelled
  /// and a new one begins immediately.
  static Future<void> scheduleBinCollectionNotifications() async {
    // Fetch bin collections and notifications from global state
    final binDays = globalStateNotifier.binDays ?? [];
    final binCollectionNotifications = globalStateNotifier.notifications ?? [];

    // Cancel any in-flight scheduling operation
    _activeCancellationToken?.cancel();
    final cancellationToken = CancellationToken();
    _activeCancellationToken = cancellationToken;

    await _scheduleBinCollectionNotifications(
      binCollectionNotifications,
      binDays,
      cancellationToken,
    );
  }
}
