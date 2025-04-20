// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Internal Imports
import 'package:bindays_app/widgets/bin_days/bin_day_groups.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_header.dart';

class BinDaysFound extends StatelessWidget {
  final List<BinDay> _binDays;
  final DateTime _lastRefresh;

  const BinDaysFound({
    super.key,
    required List<BinDay> binDays,
    required DateTime lastRefresh,
  }) : _lastRefresh = lastRefresh,
       _binDays = binDays;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BinDayHeader(binDay: _binDays.first),
          const SizedBox(height: 25),
          BinDayGroups(binDays: _binDays),
          const SizedBox(height: 25),
          Text(
            "Refreshed on ${DateFormat("dd/MM/yyyy").format(_lastRefresh)} at ${DateFormat("HH:mm").format(_lastRefresh)}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
