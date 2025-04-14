// External Imports
import 'package:bindays_app/extensions/date_time_extension.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';

class BinDayHeader extends StatelessWidget {
  final BinDay binDay;

  const BinDayHeader({super.key, required this.binDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Image.asset("assets/illustrations/Recycling_Two_Color.png"),
        ),
        Text(
          "Next Collection",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
        Text(
          binDay.date.toLongDateString(),
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
