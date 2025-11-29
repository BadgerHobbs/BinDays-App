// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/notifications_manager.dart';
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/extensions/date_time_extension.dart';

/// Change notifier for global app state changes.
class GlobalStateNotifier extends ChangeNotifier {
  Collector? _collector;
  Address? _address;
  List<BinDay>? _binDays;
  List<BinCollectionNotification>? _notifications;
  DateTime? _lastRefresh;
  bool? _darkMode;
  bool? _showBinTypeIcons;

  /// Reload all state from shared preferences.
  void reload() {
    _reloadCollector();
    _reloadAddress();
    _reloadBinDays();
    _reloadNotifications();
    _reloadLastRefresh();
    _reloadDarkMode();
    _reloadShowBinTypeIcons();
  }

  /// Notify listeners and reschedule notifications.
  void _notifyListenersAndRescheduleNotifications() {
    notifyListeners();
    NotificationsManager.scheduleBinCollectionNotifications();
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
  List<BinDay>? get binDays =>
      _binDays?.where((binDay) => binDay.date.isTodayOrAfter()).toList();

  /// Reload bin days from shared preferences.
  void _reloadBinDays() {
    _binDays = SharedPreferencesManager.getBinDays();
    _notifyListenersAndRescheduleNotifications();
  }

  /// Set bin days in shared preferences.
  Future<void> setBinDays(List<BinDay> binDays) async {
    _binDays = binDays;
    await SharedPreferencesManager.setBinDays(binDays);
    _notifyListenersAndRescheduleNotifications();
  }

  /// Get current notifications.
  List<BinCollectionNotification>? get notifications => _notifications;

  /// Reload notifications from shared preferences.
  void _reloadNotifications() {
    _notifications = SharedPreferencesManager.getNotifications();
    _notifyListenersAndRescheduleNotifications();
  }

  /// Set notifications in shared preferences.
  Future<void> setNotifications(
    List<BinCollectionNotification> notifications,
  ) async {
    _notifications = notifications;
    await SharedPreferencesManager.setNotifications(notifications);
    _notifyListenersAndRescheduleNotifications();
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

  /// Get current show bin type icons.
  bool get showBinTypeIcons => _showBinTypeIcons ?? true;

  /// Reload show bin type icons from shared preferences.
  void _reloadShowBinTypeIcons() {
    _showBinTypeIcons = SharedPreferencesManager.getShowBinTypeIcons();
    notifyListeners();
  }

  /// Set show bin type icons in shared preferences.
  Future<void> setShowBinTypeIcons(bool showBinTypeIcons) async {
    _showBinTypeIcons = showBinTypeIcons;
    await SharedPreferencesManager.setShowBinTypeIcons(showBinTypeIcons);
    notifyListeners();
  }
}
