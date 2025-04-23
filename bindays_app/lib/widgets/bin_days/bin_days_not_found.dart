// External Imports
import 'package:flutter/material.dart';

class BinDaysNotFound extends StatelessWidget {
  const BinDaysNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Image.asset(
              "assets/illustrations/Recycling_Two_Color.png",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Uh oh!",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "No upcoming bin collections were found.\nPull down to refresh.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
