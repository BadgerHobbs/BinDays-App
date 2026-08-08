// External Imports
import 'package:bindays_client/models/bin.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/bin_extension.dart';
import 'package:bindays_app/widgets/bin_days/bin_icon.dart';

class BinDayListItem extends StatelessWidget {
  final Bin bin;

  const BinDayListItem({super.key, required this.bin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      leading: BinIcon(bin: bin),
      title: Text(
        bin.name,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
        ),
      ),
      subtitle: Text(
        bin.toTypeString(),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
