// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';

class CollectorOutdatedPage extends StatelessWidget {
  const CollectorOutdatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NotFoundPage(
      headline: 'Council Website Changed',
      message:
          'Your council has changed their website and your saved address is '
          'no longer compatible.\n\n'
          'Please re-select your address to continue receiving bin collections.',
      button: PrimaryButton(
        text: 'Re-select Address',
        onPressed: () {
          setupState.collector = globalStateNotifier.collector;
          setupState.postcode = globalStateNotifier.address?.postcode;
          navigateToFindingAddressesPage(context);
        },
      ),
    );
  }
}
