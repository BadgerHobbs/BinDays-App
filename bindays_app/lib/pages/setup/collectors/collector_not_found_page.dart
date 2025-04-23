// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';

class CollectorNotFoundPage extends StatelessWidget {
  const CollectorNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postcode = setupState.postcode!;

    return NotFoundPage(
      message:
          "We couldn't automatically detect a supported collector for postcode '${postcode.toUpperCase()}'.\n\nThis might be because your collector is not yet supported, or there was an issue with our service.",
      buttonText: "Select Collector Manually",
      buttonOnPressed: () => navigateToSelectCollectorPage(context),
    );
  }
}
