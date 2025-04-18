// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/collectors/select_collector_page.dart';
import 'package:bindays_app/pages/setup/not_found_page.dart';

class CollectorNotFoundPage extends StatelessWidget {
  final String postcode;

  const CollectorNotFoundPage({super.key, required this.postcode});

  @override
  Widget build(BuildContext context) {
    return NotFoundPage(
      message:
          "We couldn't automatically detect a collector for postcode '${postcode.toUpperCase()}'. This might be because your collector is not yet supported, or there was an issue with our service. Please select your collector manually, or try again later.",
      buttonText: "Select Collector Manually",
      buttonOnPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SelectCollectorPage(postcode: postcode),
          ),
        );
      },
    );
  }
}
