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
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              binDay.date.daysUntilString(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
