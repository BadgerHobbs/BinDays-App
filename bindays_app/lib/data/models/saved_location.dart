// External Imports
import 'dart:math';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/extensions/string_extension.dart';

/// Health of a saved location's collector.
///
/// [outdated] means the council changed their website and the saved address
/// must be re-selected. [unsupported] means automatic lookups are no longer
/// available for the collector.
enum LocationStatus { ok, outdated, unsupported }

/// A single saved address, bundling its collector, cached bin days, and the
/// per-location metadata needed to support multiple addresses.
class SavedLocation {
  /// Stable, generated identifier for this location.
  final String id;

  /// Optional custom nickname (e.g. "Home", "Rental").
  String? name;

  /// The collector for this location.
  Collector collector;

  /// The address for this location.
  Address address;

  /// Cached bin days for this location.
  List<BinDay>? binDays;

  /// When this location's bin days were last refreshed.
  DateTime? lastRefresh;

  /// Health of this location's collector.
  LocationStatus status;

  SavedLocation({
    String? id,
    this.name,
    required this.collector,
    required this.address,
    this.binDays,
    this.lastRefresh,
    this.status = LocationStatus.ok,
  }) : id = id ?? _generateId();

  /// Generates a stable, reasonably unique id.
  static String _generateId() {
    final millis = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(1 << 32);
    return '$millis-$random';
  }

  /// The name to display for this location, falling back through the custom
  /// nickname, the formatted address, the postcode, and finally a generic
  /// label so the UI never shows an empty string.
  String get displayName {
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      return trimmedName;
    }

    final formatted = address.toFormattedStringNoPostcode();
    if (formatted.trim().isNotEmpty) {
      return formatted;
    }

    final postcode = address.postcode?.toUpperCase();
    if (postcode != null && postcode.trim().isNotEmpty) {
      return postcode;
    }

    return 'Saved address';
  }

  /// A short label for compact places like the app bar title. Prefers the
  /// nickname, then the town, then the street, then the postcode, so the top
  /// of the screen never shows the full multi-part address.
  String get shortName {
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      return trimmedName;
    }

    final town = address.town?.trim();
    if (town != null && town.isNotEmpty) {
      return town.capitaliseEveryWord();
    }

    final street = address.street?.trim();
    if (street != null && street.isNotEmpty) {
      return street.capitaliseEveryWord();
    }

    final postcode = address.postcode?.trim();
    if (postcode != null && postcode.isNotEmpty) {
      return postcode.toUpperCase();
    }

    return 'Address';
  }

  /// Key used to detect duplicate locations. [Address] has no value equality,
  /// so a location is considered the same property when both its collector
  /// (by gov.uk id) and address (by uid) match, falling back to the formatted
  /// address string when a uid is unavailable.
  String get dedupeKey {
    final addressKey = address.uid ?? address.toFormattedString();
    return '${collector.govUkId}|$addressKey';
  }

  /// Converts this [SavedLocation] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'collector': collector.toJson(),
      'address': address.toJson(),
      'binDays': binDays?.map((binDay) => binDay.toJson()).toList(),
      'lastRefresh': lastRefresh?.toIso8601String(),
      'status': status.name,
    };
  }

  /// Creates a [SavedLocation] from a JSON map.
  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    final binDaysJson = json['binDays'] as List<dynamic>?;
    final lastRefreshString = json['lastRefresh'] as String?;
    final statusName = json['status'] as String?;

    return SavedLocation(
      id: json['id'],
      name: json['name'],
      collector: Collector.fromJson(json['collector']),
      address: Address.fromJson(json['address']),
      binDays:
          binDaysJson?.map((binDayJson) => BinDay.fromJson(binDayJson)).toList(),
      lastRefresh:
          lastRefreshString != null ? DateTime.parse(lastRefreshString) : null,
      status: LocationStatus.values.firstWhere(
        (value) => value.name == statusName,
        orElse: () => LocationStatus.ok,
      ),
    );
  }
}
