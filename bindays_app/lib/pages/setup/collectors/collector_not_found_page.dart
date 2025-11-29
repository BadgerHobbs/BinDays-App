// External Imports
import 'package:bindays_app/widgets/primary_button.dart';
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
          "We couldn't automatically identify a supported collector for postcode '${postcode.toUpperCase()}'.\n\nThis may be due to a temporary issue with our service. Please manually select a supported collector or try again later.\n\nAlternatively, you can request support for your collector to be added below.",
      button: SecondaryButton(
        text: "Select Collector Manually",
        onPressed: () => navigateToSelectCollectorPage(context),
      ),
      extraButton: PrimaryButton(
        text: "Request Council Support",
        onPressed: () => navigateToRequestCouncilPage(context),
      ),
    );
  }
}
