// External Imports
import 'dart:convert';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Internal Imports
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/notifiers/global_state_notifier.dart';

Collector _collector({String govUkId = 'gov-1', String name = 'Test Council'}) {
  return Collector(
    name: name,
    websiteUrl: Uri.parse('https://example.com'),
    govUkId: govUkId,
    govUkUrl: Uri.parse('https://gov.uk/$govUkId'),
    version: 1,
  );
}

Address _address({
  String? property = '12',
  String? street = 'Oak Street',
  String? town = 'Leeds',
  String? postcode = 'LS1 1AA',
  String? uid = 'uid-1',
}) {
  return Address(
    property: property,
    street: street,
    town: town,
    postcode: postcode,
    uid: uid,
  );
}

BinDay _binDay(DateTime date) {
  return BinDay(
    date: date,
    address: _address(),
    bins: const [Bin(name: 'Recycling', colour: 'green', keys: ['recycling'])],
  );
}

/// Minimal notifications platform so scheduling triggered by state mutations
/// does not touch a real (uninitialised) plugin in the test isolate. With no
/// enabled notifications, scheduling only queries pending requests.
class _FakeNotificationsPlatform extends FlutterLocalNotificationsPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    return <PendingNotificationRequest>[];
  }

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    FlutterLocalNotificationsPlatform.instance = _FakeNotificationsPlatform();
  });

  group('SavedLocation', () {
    test('round-trips through JSON including status and bin days', () {
      final location = SavedLocation(
        id: 'loc-1',
        name: 'Home',
        collector: _collector(),
        address: _address(),
        binDays: [_binDay(DateTime(2026, 9, 10))],
        lastRefresh: DateTime(2026, 9, 9, 8, 30),
        status: LocationStatus.outdated,
      );

      // Mirror production, which persists via jsonEncode and reads back with
      // jsonDecode, so nested models become plain maps.
      final restored = SavedLocation.fromJson(
        jsonDecode(jsonEncode(location.toJson())),
      );

      expect(restored.id, 'loc-1');
      expect(restored.name, 'Home');
      expect(restored.collector.govUkId, 'gov-1');
      expect(restored.address.uid, 'uid-1');
      expect(restored.binDays, hasLength(1));
      expect(restored.lastRefresh, DateTime(2026, 9, 9, 8, 30));
      expect(restored.status, LocationStatus.outdated);
    });

    test('defaults status to ok for unknown values', () {
      final json = SavedLocation(
        collector: _collector(),
        address: _address(),
      ).toJson();
      json['status'] = 'nonsense';

      expect(SavedLocation.fromJson(json).status, LocationStatus.ok);
    });

    test('displayName falls back nickname -> address -> postcode -> generic', () {
      expect(
        SavedLocation(
          name: 'Rental',
          collector: _collector(),
          address: _address(),
        ).displayName,
        'Rental',
      );

      expect(
        SavedLocation(collector: _collector(), address: _address()).displayName,
        '12, Oak Street, Leeds',
      );

      expect(
        SavedLocation(
          collector: _collector(),
          address: _address(property: null, street: null, town: null),
        ).displayName,
        'LS1 1AA',
      );

      expect(
        SavedLocation(
          collector: _collector(),
          address: _address(
            property: null,
            street: null,
            town: null,
            postcode: null,
          ),
        ).displayName,
        'Saved address',
      );
    });

    test('dedupeKey combines collector gov id and address uid', () {
      final a = SavedLocation(collector: _collector(), address: _address());
      final b = SavedLocation(
        id: 'different-id',
        collector: _collector(),
        address: _address(),
      );
      final c = SavedLocation(
        collector: _collector(govUkId: 'gov-2'),
        address: _address(),
      );

      expect(a.dedupeKey, b.dedupeKey);
      expect(a.dedupeKey, isNot(c.dedupeKey));
    });
  });

  group('Migration', () {
    test('wraps legacy single-address prefs into one location', () async {
      SharedPreferences.setMockInitialValues({
        'cachedCollector':
            '{"name":"Test Council","websiteUrl":"https://example.com",'
                '"govUkId":"gov-1","govUkUrl":"https://gov.uk/gov-1","version":1}',
        'cachedAddress':
            '{"property":"12","street":"Oak Street","town":"Leeds",'
                '"postcode":"LS1 1AA","uid":"uid-1"}',
      });
      SharedPreferencesManager.resetForTesting();

      await SharedPreferencesManager.loadSharedPreferences();

      final locations = SharedPreferencesManager.getLocations();
      expect(locations, hasLength(1));
      expect(locations!.first.address.uid, 'uid-1');
      expect(
        SharedPreferencesManager.getSelectedLocationId(),
        locations.first.id,
      );
    });

    test('does not create a location when the collector is missing', () async {
      SharedPreferences.setMockInitialValues({
        'cachedAddress':
            '{"property":"12","street":"Oak Street","town":"Leeds",'
                '"postcode":"LS1 1AA","uid":"uid-1"}',
      });
      SharedPreferencesManager.resetForTesting();

      await SharedPreferencesManager.loadSharedPreferences();

      expect(SharedPreferencesManager.getLocations(), isNull);
    });
  });

  group('GlobalStateNotifier', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferencesManager.resetForTesting();
      await SharedPreferencesManager.loadSharedPreferences();
    });

    test('adds distinct locations and selects the newest', () async {
      final notifier = GlobalStateNotifier()..reload();

      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'a')),
      );
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'b')),
      );

      expect(notifier.locations, hasLength(2));
      expect(notifier.selectedLocation!.address.uid, 'b');
    });

    test('selects the existing location instead of adding a duplicate', () async {
      final notifier = GlobalStateNotifier()..reload();

      final first = SavedLocation(
        collector: _collector(),
        address: _address(uid: 'a'),
      );
      await notifier.addLocation(first);
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'b')),
      );

      // Same property as `first` (same collector + uid) with a new id.
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'a')),
      );

      expect(notifier.locations, hasLength(2));
      expect(notifier.selectedLocation!.id, first.id);
    });

    test('removing the selected location selects another', () async {
      final notifier = GlobalStateNotifier()..reload();

      final a = SavedLocation(
        collector: _collector(),
        address: _address(uid: 'a'),
      );
      final b = SavedLocation(
        collector: _collector(),
        address: _address(uid: 'b'),
      );
      await notifier.addLocation(a);
      await notifier.addLocation(b);

      // b is selected (newest); removing it should fall back to a.
      await notifier.removeLocation(b.id);

      expect(notifier.locations, hasLength(1));
      expect(notifier.selectedLocation!.id, a.id);
    });

    test('removing the last location clears the selection', () async {
      final notifier = GlobalStateNotifier()..reload();
      final a = SavedLocation(collector: _collector(), address: _address());
      await notifier.addLocation(a);

      await notifier.removeLocation(a.id);

      expect(notifier.locations, isEmpty);
      expect(notifier.selectedLocation, isNull);
    });

    test('updateLocation re-points in place and resets status', () async {
      final notifier = GlobalStateNotifier()..reload();
      final a = SavedLocation(
        collector: _collector(),
        address: _address(uid: 'a'),
        binDays: [_binDay(DateTime(2026, 9, 10))],
        status: LocationStatus.unsupported,
      );
      await notifier.addLocation(a);

      await notifier.updateLocation(
        a.id,
        collector: _collector(govUkId: 'gov-2', name: 'New Council'),
        address: _address(uid: 'z'),
      );

      final updated = notifier.selectedLocation!;
      expect(updated.id, a.id);
      expect(updated.collector.govUkId, 'gov-2');
      expect(updated.address.uid, 'z');
      expect(updated.status, LocationStatus.ok);
      expect(updated.binDays, isEmpty);
    });

    test('applyRefreshResult updates fields in one persisted write', () async {
      final notifier = GlobalStateNotifier()..reload();
      final a = SavedLocation(
        collector: _collector(),
        address: _address(),
        status: LocationStatus.outdated,
      );
      await notifier.addLocation(a);

      final when = DateTime(2026, 9, 10, 7, 0);
      await notifier.applyRefreshResult(
        a.id,
        binDays: [_binDay(DateTime(2026, 9, 11))],
        lastRefresh: when,
        status: LocationStatus.ok,
      );

      final loc = notifier.selectedLocation!;
      expect(loc.status, LocationStatus.ok);
      expect(loc.lastRefresh, when);
      expect(loc.binDays, hasLength(1));

      // The change is persisted.
      final persisted = SharedPreferencesManager.getLocations()!.first;
      expect(persisted.status, LocationStatus.ok);
      expect(persisted.binDays, hasLength(1));
    });

    test('reorderLocations moves an address and persists order', () async {
      final notifier = GlobalStateNotifier()..reload();
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'a'),
            name: 'A'),
      );
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'b'),
            name: 'B'),
      );
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'c'),
            name: 'C'),
      );

      // Order is A, B, C. Move C (index 2) to the front (newIndex 0).
      await notifier.reorderLocations(2, 0);

      expect(notifier.locations.map((l) => l.name).toList(), ['C', 'A', 'B']);
      expect(
        SharedPreferencesManager.getLocations()!.map((l) => l.name).toList(),
        ['C', 'A', 'B'],
      );
    });

    test('reload repairs a dangling selected id', () async {
      final notifier = GlobalStateNotifier()..reload();
      await notifier.addLocation(
        SavedLocation(collector: _collector(), address: _address(uid: 'a')),
      );

      // Point the persisted selection at a non-existent id, then reload.
      await SharedPreferencesManager.setSelectedLocationId('does-not-exist');
      notifier.reload();

      expect(notifier.selectedLocation, isNotNull);
      expect(
        SharedPreferencesManager.getSelectedLocationId(),
        notifier.selectedLocation!.id,
      );
    });
  });
}
