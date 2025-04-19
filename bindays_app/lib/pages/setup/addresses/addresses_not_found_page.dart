// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/pages/setup/enter_postcode_page.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';

class AddressesNotFoundPage extends StatelessWidget {
  const AddressesNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collector = setupState.collector!;
    final postcode = setupState.postcode!;

    return NotFoundPage(
      message:
          "We couldn't find any addresses for postcode '${postcode.toUpperCase()}' associated with the collector '${collector.name}'. This might mean the postcode is incorrect, the collector doesn't cover this specific postcode, or there's an issue with the address data. Please try a different postcode or collector.",
      buttonText: "Try a different postcode",
      buttonOnPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EnterPostcodePage()));
      },
    );
  }
}
