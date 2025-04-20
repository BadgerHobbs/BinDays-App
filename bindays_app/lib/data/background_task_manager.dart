// External Imports
import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
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
      backgroundFetchHeadlessTask,
    );

    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  /// Background Fetch event handler.
  static void _onBackgroundFetch(String taskId) async {
    await _refreshBinDays();
    BackgroundFetch.finish(taskId);
  }

  /// Refreshes the bin days data.
  ///
  /// Fetches the latest bin days from the server using [binDaysClient]
  /// and updates the [globalStateNotifier] with the new data and refresh time.
  static Future<void> _refreshBinDays() async {
    // Ensure app is initialised
    WidgetsFlutterBinding.ensureInitialized();

    // Initialise notifications manager
    await NotificationsManager.init();

    // Load shared preferences
    await SharedPreferencesManager.loadSharedPreferences();

    final binDays = await binDaysClient.getBinDays(
      globalStateNotifier.collector!,
      globalStateNotifier.address!,
    );
    globalStateNotifier.setBinDays(binDays);
    globalStateNotifier.setLastRefresh(DateTime.now());
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
  await BackgroundTaskManager._refreshBinDays();
  BackgroundFetch.finish(taskId);
}
