// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class CollectorUnsupportedPage extends StatelessWidget {
  final String? collectorName;

  const CollectorUnsupportedPage({super.key, this.collectorName});

  @override
  Widget build(BuildContext context) {
    final postcode = setupState.postcode?.toUpperCase() ?? "";
    final message = _buildMessage(postcode);

    return NotFoundPage(
      headline: "Collector Not Supported",
      message: message,
      button: PrimaryButton(
        text: "Select Collector Manually",
        onPressed: () => navigateToSelectCollectorPage(context),
      ),
      extraButton: SecondaryButton(
        text: "Request council support",
        onPressed: () => navigateToRequestCouncilPage(context),
      ),
    );
  }

  String _buildMessage(String postcode) {
    final formattedPostcode =
        postcode.isEmpty ? "your postcode" : "postcode '$postcode'";

    final collectorIdentifier =
        (collectorName != null && collectorName!.trim().isNotEmpty)
            ? "'${collectorName!}'"
            : "a collector";

    return "We identified $collectorIdentifier for $formattedPostcode, which we don't support yet.\n\n"
        "If we incorrectly identified your collector and it is currently supported, please select it manually. "
        "Alternatively, you can request support for your council below.";
  }
}
