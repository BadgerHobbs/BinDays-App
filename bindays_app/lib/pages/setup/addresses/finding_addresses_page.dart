// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_manager.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/setup/generics/loading_page.dart';

class FindingAddressesPage extends StatelessWidget {
  const FindingAddressesPage({super.key});

  Future<void> _getAddresses(BuildContext context) async {
    try {
      await setupManager.getAddresses();
      if (context.mounted) {
        navigateToSelectAdressPage(context, pushReplacement: true);
      }
    } catch (e) {
      if (context.mounted) {
        navigateToAddressNotFoundPage(context, pushReplacement: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAddresses(context);

    return const LoadingPage(
      titleText: "Finding Addresss",
      descriptionText:
          "Please wait while we check for addresses under your collector and postcode. This may take a few seconds.",
    );
  }
}
