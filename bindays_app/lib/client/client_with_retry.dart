// External Imports
import 'package:bindays_client/client.dart';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';

// Internal Imports
import 'package:bindays_app/misc/collector_version_error.dart';

/// [ClientWithRetry] wraps the [Client] class methods providing additional retry mechanism on failure.
class ClientWithRetry {
  final Client _client;

  ClientWithRetry(this._client);

  /// Executes [function] and retries [retryCount] times in case of failure.
  Future _getWithRetry(Function function, {int retryCount = 1}) async {
    for (int i = 0; i <= retryCount; i++) {
      try {
        return await function.call();
      } catch (e) {
        // A 410 means the collector version is permanently out of date —
        // retrying will always fail until the user re-selects their address.
        if (isCollectorVersionOutdated(e) || i == retryCount) {
          rethrow;
        }
      }
    }
    throw Exception('Operation failed after $retryCount retries.');
  }

  /// Retrieves a list of all [Collector]s.
  ///
  /// [retryCount] (Optional) Number of retry attempts (default is 1).
  ///
  /// Returns a list of [Collector] objects.
  /// Throws an [Exception] if the request fails or no collectors are found.
  Future<List<Collector>> getCollectors({int retryCount = 1}) async {
    return await _getWithRetry(
      () => _client.getCollectors(),
      retryCount: retryCount,
    );
  }

  /// Retrieves a [Collector] for a given postcode.
  ///
  /// [postcode] The postcode to search for.
  /// [retryCount] (Optional) Number of retry attempts (default is 1).
  ///
  /// Returns a [Collector] object.
  /// Throws an [Exception] if the request fails or no collector is found.
  Future<Collector> getCollector(String postcode, {int retryCount = 1}) async {
    return await _getWithRetry(
      () => _client.getCollector(postcode),
      retryCount: retryCount,
    );
  }

  /// Retrieves a list of [BinDay] for a given [Collector] and [Address].
  ///
  /// [postcode] The postcode to search for.
  /// [collector] The collector for the postcode.
  /// [retryCount] (Optional) Number of retry attempts (default is 1).
  ///
  /// Returns a list of [Address] objects.
  /// Throws an [Exception] if the request fails or no addresses are found.
  Future<List<Address>> getAddresses(
    Collector collector,
    String postcode, {
    int retryCount = 1,
  }) async {
    return await _getWithRetry(
      () => _client.getAddresses(collector, postcode),
      retryCount: retryCount,
    );
  }

  /// Fetches a list of [BinDay] instances for a specific collector and address with a retry mechanism.
  ///
  /// [collector] The collector for the address.
  /// [address] The address to search for.
  /// [retryCount] (Optional) Number of retry attempts (default is 1).
  ///
  /// Returns a list of [BinDay] objects.
  /// Throws an [Exception] if the request fails or no bin days are found.
  Future<List<BinDay>> getBinDays(
    Collector collector,
    Address address, {
    int retryCount = 1,
  }) async {
    return await _getWithRetry(
      () => _client.getBinDays(collector, address),
      retryCount: retryCount,
    );
  }
}
