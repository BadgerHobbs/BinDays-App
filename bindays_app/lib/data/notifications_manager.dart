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

  static Future<void> init({bool requestPermissions = true}) async {
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

    if (requestPermissions) {
      _requestPermissions();
    }
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

  /// Generates a stable, deterministic notification ID from [seed] so repeated
  /// background fetches (in fresh isolates) replace the existing notification
  /// rather than stacking new ones.
  static int _stableNotificationId(String seed) {
    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7FFFFFFF;
    }
    return hash;
  }

  /// Gets the notification body for the given bin day and notification.
  static String _getNotificationBody(
    BinDay binDay,
    BinCollectionNotification binCollectionNotification,
    String locationName,
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

    return "Collection of your $binsToCollect bin$plurality "
        "at $locationName is $timeframe.";
  }

  /// Schedules all bin collection notifications.
  ///
  /// Checks [cancellationToken] after each async gap; if cancelled, stops
  /// early and lets the newer call take over.
  static Future<void> _scheduleBinCollectionNotifications(
    List<BinCollectionNotification> binCollectionNotifications,
    List<({String name, List<BinDay> binDays})> locationBinDays,
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
    final activeNotifications =
        binCollectionNotifications.where((n) => n.enabled).toList();

    // Flatten all bin days across every location for the reminder anchor.
    final allBinDates = locationBinDays
        .expand((location) => location.binDays)
        .map((binDay) => binDay.date)
        .toList();

    if (activeNotifications.isEmpty || allBinDates.isEmpty) {
      return;
    }

    // Build all candidate tuples across every location, filtering out past
    // notifications, then sort by date ascending.
    final candidates =
        <
          ({
            DateTime dateTime,
            BinDay binDay,
            BinCollectionNotification notification,
            String locationName,
          })
        >[];

    for (final binCollectionNotification in activeNotifications) {
      for (final location in locationBinDays) {
        for (final binDay in location.binDays) {
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
              locationName: location.name,
            ));
          }
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
        candidate.locationName,
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

    // Anchor for the reminder: the last scheduled notification's bin day if
    // any were scheduled (earlier, since we cap at 63), otherwise the last
    // bin collection day across all locations. Whichever is earlier ensures
    // the reminder fires as soon as notifications run out.
    final lastBinDate = allBinDates.reduce((a, b) => a.isAfter(b) ? a : b);
    final anchorDate =
        toSchedule.isNotEmpty ? toSchedule.last.binDay.date : lastBinDate;

    final reminderNotification = activeNotifications.first;
    final reminderDateTime = DateTime(
      anchorDate.year,
      anchorDate.month,
      anchorDate.day,
      reminderNotification.time.hour,
      reminderNotification.time.minute,
    ).add(const Duration(days: 1));

    if (reminderDateTime.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        _generateNotificationId(),
        'Scheduled Notifications Reminder',
        'There are no more scheduled bin collection notifications. Open the app to refresh.',
        tz.TZDateTime.from(reminderDateTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  /// Shows an immediate notification informing the user that a specific
  /// saved address must be re-selected because the council's data format has
  /// changed.
  ///
  /// Uses a stable per-location notification ID so repeated background fetches
  /// replace the existing notification rather than creating duplicates.
  static Future<void> showCollectorUpdateNotification(
    String locationId,
    String locationName,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      _stableNotificationId('outdated:$locationId'),
      'Council Website Changed',
      "Your council for '$locationName' has changed their website and your "
          "saved address is no longer compatible. Open BinDays to re-select "
          "your address and continue receiving bin collections.",
      notificationDetails,
    );
  }

  /// Shows an immediate notification informing the user that a specific saved
  /// address's council is no longer supported because the collector has been
  /// removed.
  ///
  /// Uses a stable per-location notification ID so repeated background fetches
  /// replace the existing notification rather than creating duplicates.
  static Future<void> showCollectorNoLongerSupportedNotification(
    String locationId,
    String locationName,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      _stableNotificationId('unsupported:$locationId'),
      'Council No Longer Supported',
      "Your council for '$locationName' has changed their website and "
          "automatic bin day lookups are currently unavailable. Open BinDays "
          "for more details.",
      notificationDetails,
    );
  }

  /// Schedules all bin collection notifications from global state, merging the
  /// bin days of every saved location into one shared schedule.
  ///
  /// If a scheduling operation is already in progress, it is cancelled
  /// and a new one begins immediately.
  static Future<void> scheduleBinCollectionNotifications() async {
    // Fetch notifications and the bin days of every saved location.
    final binCollectionNotifications = globalStateNotifier.notifications ?? [];
    final locationBinDays = globalStateNotifier.locations
        .map(
          (location) => (
            name: location.displayName,
            binDays: location.binDays ?? <BinDay>[],
          ),
        )
        .toList();

    // Cancel any in-flight scheduling operation
    _activeCancellationToken?.cancel();
    final cancellationToken = CancellationToken();
    _activeCancellationToken = cancellationToken;

    await _scheduleBinCollectionNotifications(
      binCollectionNotifications,
      locationBinDays,
      cancellationToken,
    );
  }
}
