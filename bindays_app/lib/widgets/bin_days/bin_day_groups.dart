// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/widgets/bin_days/bin_day_list_group.dart';

class BinDayGroups extends StatelessWidget {
  final List<BinDay> binDays;

  const BinDayGroups({super.key, required this.binDays});

  @override
  Widget build(BuildContext context) {
    // Sort bin days by date asc
    binDays.sort((a, b) => a.date.compareTo(b.date));

    return Column(
      spacing: 25,
      children:
          binDays.map((binDay) => BinDayListGroup(binDay: binDay)).toList(),
    );
  }
}
