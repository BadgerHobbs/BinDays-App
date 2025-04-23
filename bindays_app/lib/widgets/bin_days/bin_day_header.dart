// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/date_time_extension.dart';

class BinDayHeader extends StatelessWidget {
  final BinDay binDay;

  const BinDayHeader({super.key, required this.binDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 25,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Image.asset(
            "assets/illustrations/Recycling_Two_Color.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Next Collection",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                binDay.date.toLongDateString(),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
