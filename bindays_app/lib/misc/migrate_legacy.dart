// External Imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bindays_client/models/address.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_collection_notification.dart';

/// Class to migrate legacy data from shared preferences.
class MigrateLegacy {
  /// Migrates the dark mode setting from shared preferences.
  static bool? migrateDarkMode(SharedPreferences sharedPreferences) {
    return sharedPreferences.getBool("IsDarkMode");
  }

  /// Migrates the notifications from shared preferences.
  static List<BinCollectionNotification>? migrateNotifications(
    SharedPreferences sharedPreferences,
  ) {
    final notificationsString = sharedPreferences.getString(
      "savedNotifications",
    );
    if (notificationsString == null) {
      return null;
    }

    final notificationsJson = jsonDecode(notificationsString);
    final notifications = <BinCollectionNotification>[];

    for (var notificationJson in notificationsJson) {
      final notification = _parseNotification(notificationJson);
      notifications.add(notification);
    }

    return notifications;
  }

  /// Migrates the address from shared preferences.
  static Address? migrateAddress(SharedPreferences sharedPreferences) {
    final addressString = sharedPreferences.getString("savedAddress");
    if (addressString == null) {
      return null;
    }

    final addressJson = jsonDecode(addressString);
    final address = Address(
      property: addressJson["property"],
      street: addressJson["street"],
      town: addressJson["town"],
      postcode: addressJson["postcode"],
      uid: addressJson["uid"],
    );

    return address;
  }

  /// Parses a notification from a JSON object.
  static BinCollectionNotification _parseNotification(
    Map<String, dynamic> json,
  ) {
    return BinCollectionNotification(
      enabled: json["enabled"],
      time: _parseTimeOfDayString(json["time"]),
      durationBeforeCollection: _parseDaysString(json["day"]),
    );
  }

  /// Parses a days string to a duration.
  static Duration _parseDaysString(String daysString) {
    final dayOptions = {
      "On Collection Day": 0,
      "1 Day Before Collection": 1,
      "2 Days Before Collection": 2,
      "3 Days Before Collection": 3,
      "4 Days Before Collection": 4,
      "5 Days Before Collection": 5,
      "6 Days Before Collection": 6,
      "7 Days Before Collection": 7,
    };

    return Duration(days: dayOptions[daysString] ?? 0);
  }

  /// Parses a time of day string to a TimeOfDay object.
  static TimeOfDay _parseTimeOfDayString(String timeOfDayString) {
    String lowerCaseTimeOfDayString = timeOfDayString.toLowerCase();

    if (lowerCaseTimeOfDayString.contains("am") ||
        lowerCaseTimeOfDayString.contains("pm")) {
      int hour = int.parse(timeOfDayString.split(" ")[0].split(":")[0]);
      int minute = int.parse(timeOfDayString.split(" ")[0].split(":")[1]);
      String timeOfDay = timeOfDayString.split(" ")[1];

      if (timeOfDay == "pm") {
        hour += 12;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } else {
      int hour = int.parse(timeOfDayString.split(" ")[0].split(":")[0]);
      int minute = int.parse(timeOfDayString.split(" ")[0].split(":")[1]);

      return TimeOfDay(hour: hour, minute: minute);
    }
  }
}
