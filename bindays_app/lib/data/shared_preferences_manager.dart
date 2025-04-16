// External Imports
import 'dart:convert';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages shared preferences.
class SharedPreferencesManager {
  static SharedPreferences? _sharedPreferences;

  static const _collectorKey = 'cachedCollector';
  static const _addressKey = 'cachedAddress';
  static const _binDaysKey = 'cachedBinDays';

  static Future<SharedPreferences> get sharedPreferences async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _migrateLegacyData();
    return _sharedPreferences!;
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

  static Future<void> reload() async {
    await _sharedPreferences?.reload();
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
}
