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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Both texts take a share of the row and wrap if needed, so large
            // fonts never push the countdown off the right edge. The date gets
            // the larger share as it is the longer, primary text.
            Expanded(
              flex: 3,
              child: Text(
                binDay.date.toLongDateString(),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                binDay.date.daysUntilString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
