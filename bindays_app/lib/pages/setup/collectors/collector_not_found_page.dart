// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_manager.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';

class CollectorNotFoundPage extends StatelessWidget {
  const CollectorNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postcode = setupManager.postcode!;

    return NotFoundPage(
      message:
          "We couldn't automatically detect a collector for postcode '${postcode.toUpperCase()}'. This might be because your collector is not yet supported, or there was an issue with our service. Please select your collector manually, or try again later.",
      buttonText: "Select Collector Manually",
      buttonOnPressed: () => navigateToSelectCollectorPage(context),
    );
  }
}
