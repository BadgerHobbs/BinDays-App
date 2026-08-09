// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_group.dart';
import 'package:bindays_app/extensions/bin_extension.dart';
import 'package:bindays_app/extensions/date_time_extension.dart';
import 'package:bindays_app/widgets/bin_days/bin_icon.dart';

class BinGroupListItem extends StatelessWidget {
  final BinGroup binGroup;

  const BinGroupListItem({super.key, required this.binGroup});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      leading: BinIcon(bin: binGroup.bin),
      title: Text(
        binGroup.bin.name,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
        ),
      ),
      subtitle: Text(
        binGroup.bin.toTypeString(),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            binGroup.nextDate.toShortDateString(),
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            binGroup.nextDate.daysUntilString(),
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
