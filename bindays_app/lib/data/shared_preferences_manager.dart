// External Imports
import 'dart:convert';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';

/// Manages shared preferences.
class SharedPreferencesManager {
  static SharedPreferences? _sharedPreferences;

  static const _collectorKey = 'cachedCollector';
  static const _addressKey = 'cachedAddress';
  static const _binDaysKey = 'cachedBinDays';
  static const _notificationsKey = 'cachedNotifications';
  static const _lastRefreshKey = 'cachedLastRefresh';
  static const _isDarkModeKey = 'cachedIsDarkMode';

  static Future<void> loadSharedPreferences() async {
    if (_sharedPreferences != null) return;
    _sharedPreferences = await SharedPreferences.getInstance();
    await _migrateLegacyData();
  }

  /// Migrate data from legacy 1.x version
  static Future<void> _migrateLegacyData() async {
    // TODO
    // - Get legacy shared preferences data (if exists)
    //   - 'Address'
    //   - 'BinDays'
    //   - 'LastRefresh'
    //   - 'savedNotifications'
    //   - 'IsDarkMode'
    // - Migrate to new format and save
    // - Remove legacy shared preferences data
  }

  /// Generic method to get and parse shared preferences json
  static dynamic getSharedPreferenceJson(String key) {
    final json = _sharedPreferences?.getString(key);
    if (json == null) return null;
    return jsonDecode(json);
  }

  /// Set shared preferences json.
  static Future<void> setSharedPreferenceJson(String key, String json) async {
    await _sharedPreferences?.setString(key, json);
  }

  /// Get collector from shared preferences json.
  static Collector? getCollector() {
    final collectorJson = getSharedPreferenceJson(_collectorKey);
    if (collectorJson == null) return null;
    return Collector.fromJson(collectorJson);
  }

  /// Set collector shared preferences json.
  static Future<void> setCollector(Collector collector) async {
    final collectorJson = collector.toJson();
    await setSharedPreferenceJson(_collectorKey, jsonEncode(collectorJson));
  }

  /// Get address from shared preferences json.
  static Address? getAddress() {
    final addressJson = getSharedPreferenceJson(_addressKey);
    if (addressJson == null) return null;
    return Address.fromJson(addressJson);
  }

  /// Set address shared preferences json.
  static Future<void> setAddress(Address address) async {
    final addressJson = address.toJson();
    await setSharedPreferenceJson(_addressKey, jsonEncode(addressJson));
  }

  /// Get bin days from shared preferences json.
  static List<BinDay>? getBinDays() {
    final binDaysJson = getSharedPreferenceJson(_binDaysKey);
    if (binDaysJson == null) return null;

    List<BinDay> binDays = [];
    for (var binDayJson in binDaysJson) {
      binDays.add(BinDay.fromJson(binDayJson));
    }
    return binDays;
  }

  /// Set bin days shared preferences json.
  static Future<void> setBinDays(List<BinDay> binDays) async {
    final binDaysJson = binDays.map((binDay) => binDay.toJson()).toList();
    await setSharedPreferenceJson(_binDaysKey, jsonEncode(binDaysJson));
  }

  /// Get notifications from shared preferences json.
  static List<BinCollectionNotification>? getNotifications() {
    final notificationsJson = getSharedPreferenceJson(_notificationsKey);
    if (notificationsJson == null) return null;

    List<BinCollectionNotification> notifications = [];
    for (var notificationJson in notificationsJson) {
      notifications.add(BinCollectionNotification.fromJson(notificationJson));
    }
    return notifications;
  }

  /// Set notifications shared preferences json.
  static Future<void> setNotifications(
    List<BinCollectionNotification> notifications,
  ) async {
    final notificationsJson =
        notifications.map((notification) => notification.toJson()).toList();
    await setSharedPreferenceJson(
      _notificationsKey,
      jsonEncode(notificationsJson),
    );
  }

  /// Get last refresh from shared preferences json.
  static DateTime? getLastRefresh() {
    final lastRefreshString = _sharedPreferences?.getString(_lastRefreshKey);
    if (lastRefreshString == null) return null;
    return DateTime.parse(lastRefreshString);
  }

  /// Set last refresh shared preferences json.
  static Future<void> setLastRefresh(DateTime lastRefresh) async {
    await _sharedPreferences?.setString(
      _lastRefreshKey,
      lastRefresh.toIso8601String(),
    );
  }

  /// Get is dark mode from shared preferences json.
  static bool getIsDarkMode() {
    return _sharedPreferences?.getBool(_isDarkModeKey) ?? false;
  }

  /// Set is dark mode shared preferences json.
  static Future<void> setIsDarkMode(bool isDarkMode) async {
    await _sharedPreferences?.setBool(_isDarkModeKey, isDarkMode);
  }
}
