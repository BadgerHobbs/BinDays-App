// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';

/// Change notifier for global app state changes.
class GlobalStateNotifier extends ChangeNotifier {
  Collector? _collector;
  Address? _address;
  List<BinDay>? _binDays;
  List<BinCollectionNotification>? _notifications;
  DateTime? _lastRefresh;
  bool? _darkMode;

  /// Reload all state from shared preferences.
  void reload() {
    _reloadCollector();
    _reloadAddress();
    _reloadBinDays();
    _reloadNotifications();
    _reloadLastRefresh();
    _reloadDarkMode();
  }

  /// Get current collector.
  Collector? get collector => _collector;

  /// Reload collector from shared preferences.
  void _reloadCollector() {
    _collector = SharedPreferencesManager.getCollector();
    notifyListeners();
  }

  /// Set collector in shared preferences.
  Future<void> setCollector(Collector collector) async {
    _collector = collector;
    await SharedPreferencesManager.setCollector(collector);
    notifyListeners();
  }

  /// Get current address.
  Address? get address => _address;

  /// Reload address from shared preferences.
  void _reloadAddress() {
    _address = SharedPreferencesManager.getAddress();
    notifyListeners();
  }

  /// Set address in shared preferences.
  Future<void> setAddress(Address address) async {
    _address = address;
    await SharedPreferencesManager.setAddress(address);
    notifyListeners();
  }

  /// Get current bin days.
  List<BinDay>? get binDays => _binDays;

  /// Reload bin days from shared preferences.
  void _reloadBinDays() {
    _binDays = SharedPreferencesManager.getBinDays();
    notifyListeners();
  }

  /// Set bin days in shared preferences.
  Future<void> setBinDays(List<BinDay> binDays) async {
    _binDays = binDays;
    await SharedPreferencesManager.setBinDays(binDays);
    notifyListeners();
  }

  /// Get current notifications.
  List<BinCollectionNotification>? get notifications => _notifications;

  /// Reload notifications from shared preferences.
  void _reloadNotifications() {
    _notifications = SharedPreferencesManager.getNotifications();
    notifyListeners();
  }

  /// Set notifications in shared preferences.
  Future<void> setNotifications(
    List<BinCollectionNotification> notifications,
  ) async {
    _notifications = notifications;
    await SharedPreferencesManager.setNotifications(notifications);
    notifyListeners();
  }

  /// Get current last refresh.
  DateTime? get lastRefresh => _lastRefresh;

  /// Reload last refresh from shared preferences.
  void _reloadLastRefresh() {
    _lastRefresh = SharedPreferencesManager.getLastRefresh();
    notifyListeners();
  }

  /// Set last refresh in shared preferences.
  Future<void> setLastRefresh(DateTime lastRefresh) async {
    _lastRefresh = lastRefresh;
    await SharedPreferencesManager.setLastRefresh(lastRefresh);
    notifyListeners();
  }

  /// Get current dark mode.
  bool get isDarkMode => _darkMode ?? false;

  /// Reload dark mode from shared preferences.
  void _reloadDarkMode() {
    _darkMode = SharedPreferencesManager.getIsDarkMode();
    notifyListeners();
  }

  /// Set dark mode in shared preferences.
  Future<void> setIsDarkMode(bool isDarkMode) async {
    _darkMode = isDarkMode;
    await SharedPreferencesManager.setIsDarkMode(isDarkMode);
    notifyListeners();
  }
}
