// External Imports
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/pages/setup/enter_postcode_page.dart';
import 'package:bindays_app/pages/setup/not_found_page.dart';

class AddressesNotFoundPage extends StatelessWidget {
  final String postcode;
  final Collector collector;

  const AddressesNotFoundPage({
    super.key,
    required this.postcode,
    required this.collector,
  });

  @override
  Widget build(BuildContext context) {
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
