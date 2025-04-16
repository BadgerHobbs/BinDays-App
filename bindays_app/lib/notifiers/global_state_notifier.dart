// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/shared_preferences_manager.dart';

/// Change notifier for global app state changes.
class GlobalStateNotifier extends ChangeNotifier {
  bool darkMode = false;

  Collector? _collector;
  Address? _address;
  List<BinDay>? _binDays;

  /// Reload all state from shared preferences.
  void reload() {
    _reloadCollector();
    _reloadAddress();
    _reloadBinDays();
  }

  /// Get current collector.
  Collector? get collector => _collector;

  /// Reload collector from shared preferences.
  void _reloadCollector() {
    _collector = SharedPreferencesManager.getCollector();
    notifyListeners();
  }

  /// Set collector in shared preferences.
  Future<void> setCollector() async {
    await SharedPreferencesManager.setCollector(_collector!);
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
  Future<void> setAddress() async {
    await SharedPreferencesManager.setAddress(_address!);
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
  Future<void> setBinDays() async {
    await SharedPreferencesManager.setBinDays(_binDays!);
    notifyListeners();
  }
}
