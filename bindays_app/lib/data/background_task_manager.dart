// External Imports
import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/data/notifications_manager.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/misc/collector_version_error.dart';
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

  /// Refreshes the bin days data.
  ///
  /// Fetches the latest bin days from the server using [binDaysClient]
  /// and updates the [globalStateNotifier] with the new data and refresh time.
  static Future<void> _refreshBinDays() async {
    // Ensure app is initialised
    WidgetsFlutterBinding.ensureInitialized();

    // Initialise timezone (for notifications)
    tz.initializeTimeZones();

    // Load shared preferences
    await SharedPreferencesManager.loadSharedPreferences();

    // Load shared preferences into global state notifier
    globalStateNotifier.reload();

    // Skip if collector and address not yet set
    if (globalStateNotifier.collector == null ||
        globalStateNotifier.address == null) {
      return;
    }

    try {
      final binDays = await binDaysClient.getBinDays(
        globalStateNotifier.collector!,
        globalStateNotifier.address!,
      );
      globalStateNotifier.setBinDays(binDays);
      globalStateNotifier.setLastRefresh(DateTime.now());
    } catch (e) {
      if (isCollectorVersionOutdated(e)) {
        // init() is called here because in headless mode the notification
        // plugin may not have been initialised by the normal app startup path.
        await NotificationsManager.init();
        await NotificationsManager.showCollectorUpdateNotification();
      }
    }
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
