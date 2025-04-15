// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/date_time_extension.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_list_item.dart';

class BinDayListGroup extends StatelessWidget {
  final BinDay binDay;

  const BinDayListGroup({super.key, required this.binDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              binDay.date.toLongDateString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              binDay.date.daysUntilString(),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        Column(
          children: binDay.bins.map((bin) => BinDayListItem(bin: bin)).toList(),
        ),
      ],
    );
  }
}
