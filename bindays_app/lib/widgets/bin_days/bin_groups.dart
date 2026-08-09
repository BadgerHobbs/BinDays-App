// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/bin_group.dart';
import 'package:bindays_app/widgets/bin_days/bin_group_list_item.dart';

class BinGroups extends StatelessWidget {
  final List<BinDay> binDays;

  const BinGroups({super.key, required this.binDays});

  @override
  Widget build(BuildContext context) {
    final binGroups = BinGroup.fromBinDays(binDays);

    return Column(
      children:
          binGroups
              .map((binGroup) => BinGroupListItem(binGroup: binGroup))
              .toList(),
    );
  }
}
