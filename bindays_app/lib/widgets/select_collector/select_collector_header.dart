// External Imports
import 'package:flutter/material.dart';

class SelectCollectorHeader extends StatelessWidget {
  const SelectCollectorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Supported Collectors",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(68, 68, 68, 1),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Please select a supported collector to continue.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color.fromRGBO(68, 68, 68, 1)),
        ),
      ],
    );
  }
}
