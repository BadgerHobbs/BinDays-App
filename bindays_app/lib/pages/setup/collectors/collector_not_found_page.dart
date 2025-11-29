// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class CollectorNotFoundPage extends StatelessWidget {
  const CollectorNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postcode = setupState.postcode!;

    return NotFoundPage(
      message:
          "We couldn't automatically identify a supported collector for postcode '${postcode.toUpperCase()}'.\n\nThis might be because of a temporary issue with our service. Please try selecting a collector manually or try again later.",
      button: SecondaryButton(
        text: "Select Collector Manually",
        onPressed: () => navigateToSelectCollectorPage(context),
      ),
    );
  }
}
