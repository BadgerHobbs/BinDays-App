// External Imports
import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

// Internal Imports
import 'package:bindays_app/data/location_refresh_service.dart';
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/notifications_manager.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';

@pragma('vm:entry-point')
class BackgroundTaskManager {
  /// Initializes the BackgroundFetch and registers a periodic task to refresh bin days every 9 hours.
  static Future<void> init() async {
    // Configure BackgroundFetch.
    // https://pub.dev/documentation/background_fetch/latest/background_fetch/BackgroundFetchConfig-class.html
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 60 * 9,
        enableHeadless: true,
        startOnBoot: true,
        stopOnTerminate: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onBackgroundFetch,
      _onBackgroundTimeout,
    );

    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  /// Background Fetch event handler.
  static void _onBackgroundFetch(String taskId) async {
    try {
      await BackgroundTaskManager._refreshBinDays();
    } finally {
      BackgroundFetch.finish(taskId);
    }
  }

  static void _onBackgroundTimeout(String taskId) {
    BackgroundFetch.finish(taskId);
  }

  /// Refreshes the bin days data for every saved location.
  ///
  /// Fetches the latest bin days from the server using [binDaysClient]
  /// and updates each location with the new data and refresh time. Each
  /// location is refreshed independently so one failing collector does not
  /// prevent the others from updating.
  static Future<void> _refreshBinDays() async {
    // Ensure app is initialised
    WidgetsFlutterBinding.ensureInitialized();

    // Initialise timezone (for notifications)
    tz.initializeTimeZones();

    // Load shared preferences
    await SharedPreferencesManager.loadSharedPreferences();

    // Load shared preferences into global state notifier
    globalStateNotifier.reload();

    // Skip if no locations are set up yet.
    if (globalStateNotifier.locations.isEmpty) {
      return;
    }

    // init() is called here because in headless mode the notification plugin
    // may not have been initialised by the normal app startup path.
    // requestPermissions: false avoids triggering a permission dialog from a
    // background context.
    await NotificationsManager.init(requestPermissions: false);

    // Refresh the selected/most-stale locations first so the visible one is
    // up to date even if the OS cuts the background task short.
    final locations = [...globalStateNotifier.locations];
    final selectedId = globalStateNotifier.selectedLocation?.id;
    locations.sort((a, b) {
      if (a.id == selectedId) return -1;
      if (b.id == selectedId) return 1;
      final aRefresh = a.lastRefresh;
      final bRefresh = b.lastRefresh;
      if (aRefresh == null && bRefresh == null) return 0;
      if (aRefresh == null) return -1;
      if (bRefresh == null) return 1;
      return aRefresh.compareTo(bRefresh);
    });

    for (final location in locations) {
      try {
        final result = await LocationRefreshService.refreshLocation(location);
        if (result.status == LocationStatus.outdated) {
          await NotificationsManager.showCollectorUpdateNotification(
            location.id,
            location.displayName,
          );
        } else if (result.status == LocationStatus.unsupported) {
          await NotificationsManager.showCollectorNoLongerSupportedNotification(
            location.id,
            location.displayName,
          );
        }
      } catch (e) {
        // Unknown (e.g. network) errors are swallowed so remaining locations
        // still refresh.
      }
    }

    // Reschedule notifications once, after all locations have been refreshed.
    globalStateNotifier.rescheduleNotifications();
  }
}

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    BackgroundFetch.finish(taskId);
    return;
  }
  try {
    await BackgroundTaskManager._refreshBinDays();
  } finally {
    BackgroundFetch.finish(taskId);
  }
}
