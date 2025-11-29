// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class AddressesNotFoundPage extends StatelessWidget {
  const AddressesNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collector = setupState.collector!;
    final postcode = setupState.postcode!;

    return NotFoundPage(
      message:
          "We couldn't find any addresses for postcode '${postcode.toUpperCase()}' associated with the collector '${collector.name}'.\n\nThis might be because the collector is missing data for the postcode, or there was an issue with our service.",
      button: SecondaryButton(
        text: "Try a different postcode",
        onPressed: () => navigateToEnterPostcodePage(context),
      ),
    );
  }
}
