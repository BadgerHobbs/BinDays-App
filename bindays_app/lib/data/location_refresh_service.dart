// External Imports
import 'package:bindays_client/models/bin_day.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/misc/collector_unsupported_error.dart';
import 'package:bindays_app/misc/collector_version_error.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';

/// The outcome of refreshing a single location.
class LocationRefreshResult {
  /// The resulting health of the location's collector.
  final LocationStatus status;

  /// The fetched bin days, non-null only when [status] is [LocationStatus.ok].
  final List<BinDay>? binDays;

  const LocationRefreshResult(this.status, [this.binDays]);
}

/// Fetches bin days for a single location and writes the result back to the
/// [globalStateNotifier], mapping collector errors to a [LocationStatus].
///
/// Shared by the foreground bin days view and the background task so both
/// handle fetch, write-back, and error classification identically. The write
/// is a single persist and does not reschedule notifications; callers
/// reschedule once via [GlobalStateNotifier.rescheduleNotifications].
class LocationRefreshService {
  /// Refreshes [location]. Returns the outcome. Unexpected (e.g. network)
  /// errors are rethrown so the caller can decide how to handle them.
  static Future<LocationRefreshResult> refreshLocation(
    SavedLocation location,
  ) async {
    try {
      final binDays = await binDaysClient.getBinDays(
        location.collector,
        location.address,
      );
      await globalStateNotifier.applyRefreshResult(
        location.id,
        binDays: binDays,
        lastRefresh: DateTime.now(),
        status: LocationStatus.ok,
      );
      return LocationRefreshResult(LocationStatus.ok, binDays);
    } catch (e) {
      if (isCollectorVersionOutdated(e)) {
        await globalStateNotifier.applyRefreshResult(
          location.id,
          status: LocationStatus.outdated,
        );
        return const LocationRefreshResult(LocationStatus.outdated);
      } else if (isCollectorNoLongerSupported(e)) {
        await globalStateNotifier.applyRefreshResult(
          location.id,
          status: LocationStatus.unsupported,
        );
        return const LocationRefreshResult(LocationStatus.unsupported);
      }
      rethrow;
    }
  }
}
