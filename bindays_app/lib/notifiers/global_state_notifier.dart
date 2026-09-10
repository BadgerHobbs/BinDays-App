// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/notifications_manager.dart';
import 'package:bindays_app/data/models/bin_collection_notification.dart';
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/extensions/date_time_extension.dart';

/// Change notifier for global app state changes.
class GlobalStateNotifier extends ChangeNotifier {
  List<SavedLocation> _locations = [];
  String? _selectedLocationId;
  List<BinCollectionNotification>? _notifications;
  bool? _darkMode;
  bool? _showBinTypeIcons;
  bool? _groupByBin;

  /// Reload all state from shared preferences.
  void reload() {
    _reloadLocations();
    _reloadNotifications();
    _reloadDarkMode();
    _reloadShowBinTypeIcons();
    _reloadGroupByBin();
  }

  /// Notify listeners and reschedule notifications.
  void _notifyListenersAndRescheduleNotifications() {
    notifyListeners();
    NotificationsManager.scheduleBinCollectionNotifications();
  }

  /// Persist the current locations and selected id, then notify + reschedule.
  Future<void> _persistLocations({bool reschedule = true}) async {
    await SharedPreferencesManager.setLocations(_locations);
    await SharedPreferencesManager.setSelectedLocationId(_selectedLocationId);
    if (reschedule) {
      _notifyListenersAndRescheduleNotifications();
    } else {
      notifyListeners();
    }
  }

  /// Get all saved locations.
  List<SavedLocation> get locations => _locations;

  /// Get the currently selected location, falling back to the first location
  /// if the selected id is missing or dangling.
  SavedLocation? get selectedLocation {
    if (_locations.isEmpty) return null;
    for (final location in _locations) {
      if (location.id == _selectedLocationId) return location;
    }
    return _locations.first;
  }

  /// Reload locations and selected id from shared preferences.
  void _reloadLocations() {
    _locations = SharedPreferencesManager.getLocations() ?? [];
    _selectedLocationId = SharedPreferencesManager.getSelectedLocationId();

    // Repair a dangling selected id so it always points at a real location.
    if (_locations.isNotEmpty &&
        !_locations.any((location) => location.id == _selectedLocationId)) {
      _selectedLocationId = _locations.first.id;
      SharedPreferencesManager.setSelectedLocationId(_selectedLocationId);
    }

    _notifyListenersAndRescheduleNotifications();
  }

  /// Add a new location and select it. If an equivalent location already
  /// exists it is selected instead of adding a duplicate.
  Future<void> addLocation(SavedLocation location) async {
    final existing = _locations.where(
      (element) => element.dedupeKey == location.dedupeKey,
    );
    if (existing.isNotEmpty) {
      _selectedLocationId = existing.first.id;
      await _persistLocations(reschedule: false);
      return;
    }

    _locations = [..._locations, location];
    _selectedLocationId = location.id;
    await _persistLocations();
  }

  /// Remove a location. If it was selected, select the first remaining one.
  Future<void> removeLocation(String id) async {
    _locations = _locations.where((element) => element.id != id).toList();
    if (_selectedLocationId == id) {
      _selectedLocationId = _locations.isNotEmpty ? _locations.first.id : null;
    }
    await _persistLocations();
  }

  /// Set the custom nickname for a location (null or empty clears it).
  Future<void> renameLocation(String id, String? name) async {
    final trimmed = name?.trim();
    _updateLocationInPlace(id, (location) {
      location.name = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    });
    // Rename changes the address named in shared notification bodies.
    await _persistLocations();
  }

  /// Reorder the saved locations, which is also the order of the swipeable
  /// pages on the bin days screen. Uses [ReorderableListView] index semantics.
  Future<void> reorderLocations(int oldIndex, int newIndex) async {
    if (oldIndex < 0 || oldIndex >= _locations.length) return;
    var target = newIndex;
    if (target > oldIndex) target -= 1;

    final reordered = [..._locations];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(target.clamp(0, reordered.length), moved);
    _locations = reordered;

    // Reflect the new order immediately so the reorder animation settles
    // smoothly, then persist. Order does not affect notification content, and
    // the selected id is unchanged, so neither is rewritten here.
    notifyListeners();
    await SharedPreferencesManager.setLocations(_locations);
  }

  /// Set the selected location.
  Future<void> setSelectedLocation(String id) async {
    _selectedLocationId = id;
    await SharedPreferencesManager.setSelectedLocationId(id);
    notifyListeners();
  }

  /// Re-point an existing location at a new collector/address, keeping its id
  /// and nickname. Resets cached bin days and status ready for a refresh.
  Future<void> updateLocation(
    String id, {
    required Collector collector,
    required Address address,
  }) async {
    _updateLocationInPlace(id, (location) {
      location.collector = collector;
      location.address = address;
      location.binDays = [];
      location.lastRefresh = null;
      location.status = LocationStatus.ok;
    });
    await _persistLocations();
  }

  /// Apply the outcome of a refresh to a location in a single write.
  ///
  /// Updates whichever of [binDays], [lastRefresh] and [status] are provided,
  /// then persists the locations list once. Does not reschedule notifications;
  /// callers reschedule once via [rescheduleNotifications] after a batch of
  /// refreshes so notifications aren't rebuilt repeatedly.
  Future<void> applyRefreshResult(
    String id, {
    List<BinDay>? binDays,
    DateTime? lastRefresh,
    LocationStatus? status,
  }) async {
    _updateLocationInPlace(id, (location) {
      if (binDays != null) location.binDays = binDays;
      if (lastRefresh != null) location.lastRefresh = lastRefresh;
      if (status != null) location.status = status;
    });
    await _persistLocations(reschedule: false);
  }

  /// Reschedule bin collection notifications from the current state.
  void rescheduleNotifications() {
    NotificationsManager.scheduleBinCollectionNotifications();
  }

  /// Apply a mutation to the location with the given id, if present.
  void _updateLocationInPlace(
    String id,
    void Function(SavedLocation location) mutate,
  ) {
    for (final location in _locations) {
      if (location.id == id) {
        mutate(location);
        return;
      }
    }
  }

  /// Get the selected location's collector.
  Collector? get collector => selectedLocation?.collector;

  /// Get the selected location's address.
  Address? get address => selectedLocation?.address;

  /// Get the selected location's upcoming bin days.
  List<BinDay>? get binDays => selectedLocation?.binDays
      ?.where((binDay) => binDay.date.isTodayOrAfter())
      .toList();

  /// Get the selected location's last refresh time.
  DateTime? get lastRefresh => selectedLocation?.lastRefresh;

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

  /// Get current group by bin.
  bool get groupByBin => _groupByBin ?? false;

  /// Reload group by bin from shared preferences.
  void _reloadGroupByBin() {
    _groupByBin = SharedPreferencesManager.getGroupByBin();
    notifyListeners();
  }

  /// Set group by bin in shared preferences.
  Future<void> setGroupByBin(bool groupByBin) async {
    _groupByBin = groupByBin;
    await SharedPreferencesManager.setGroupByBin(groupByBin);
    notifyListeners();
  }
}
