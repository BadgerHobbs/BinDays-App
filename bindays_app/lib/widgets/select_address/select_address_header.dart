// External Imports
import 'package:flutter/material.dart';

class SelectAddressHeader extends StatelessWidget {
  const SelectAddressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Addresses",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(68, 68, 68, 1),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Please select an address to continue.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color.fromRGBO(68, 68, 68, 1)),
        ),
      ],
    );
  }
}
