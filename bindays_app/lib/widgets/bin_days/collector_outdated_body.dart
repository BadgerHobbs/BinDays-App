// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/widgets/primary_button.dart';

/// Inline failure state shown on the bin days screen when a location's
/// collector is outdated and its address must be re-selected.
///
/// Rendered in the body so switching to a working address stays available.
class CollectorOutdatedBody extends StatelessWidget {
  final SavedLocation location;

  const CollectorOutdatedBody({super.key, required this.location});

  void _reselectAddress(BuildContext context) {
    // Re-run address selection for this location's existing collector,
    // updating it in place rather than adding a new location.
    setupState.reset(editingLocationId: location.id);
    setupState.collector = location.collector;
    setupState.postcode = location.address.postcode;
    navigateToFindingAddressesPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Image.asset(
              'assets/illustrations/Navigation_Two_Color.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Council Website Changed',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Your council has changed their website and this saved address is '
            'no longer compatible.\n\n'
            'Please re-select your address to continue receiving bin '
            'collections.',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          PrimaryButton(
            text: 'Re-select Address',
            onPressed: () => _reselectAddress(context),
          ),
        ],
      ),
    );
  }
}
