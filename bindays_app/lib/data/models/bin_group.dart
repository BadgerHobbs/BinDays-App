// External Imports
import 'package:bindays_client/models/bin.dart';
import 'package:bindays_client/models/bin_day.dart';

/// Represents a bin and the next date it is collected on.
class BinGroup {
  /// The bin being collected.
  final Bin bin;

  /// The next date the bin is collected on.
  final DateTime nextDate;

  const BinGroup({required this.bin, required this.nextDate});

  /// Flattens bin days into one group per bin, keeping only the earliest
  /// (next) date for each, sorted soonest first then by name.
  static List<BinGroup> fromBinDays(List<BinDay> binDays) {
    final Map<String, BinGroup> groups = {};
    for (final binDay in binDays) {
      for (final bin in binDay.bins) {
        final existing = groups[bin.name];
        if (existing == null || binDay.date.isBefore(existing.nextDate)) {
          groups[bin.name] = BinGroup(bin: bin, nextDate: binDay.date);
        }
      }
    }

    // Bins sharing a next date are common, so order those by name to keep
    // the list stable between refreshes.
    return groups.values.toList()..sort((a, b) {
      final dateOrder = a.nextDate.compareTo(b.nextDate);
      return dateOrder != 0 ? dateOrder : a.bin.name.compareTo(b.bin.name);
    });
  }
}
