// External Imports
import 'package:bindays_app/data/notifications_manager.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';

@pragma('vm:entry-point')
class BackgroundTaskManager {
  /// Initializes the Workmanager and registers a periodic task to refresh bin days.
  ///
  /// The task runs every 9 hours with an initial delay of 9 hours.
  static void init() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    Workmanager().registerPeriodicTask(
      "RefreshBinDays",
      "RefreshBinDaysPeriodicTask",
      frequency: const Duration(hours: 9),
      initialDelay: const Duration(hours: 9),
      existingWorkPolicy: ExistingWorkPolicy.append,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Callback dispatcher for Workmanager tasks.
  ///
  /// This function is called by Workmanager to execute tasks in the background.
  /// It calls [_refreshBinDays] to update the bin days data.
  static void callbackDispatcher() async {
    Workmanager().executeTask((task, inputData) async {
      try {
        await _refreshBinDays();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    });
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
