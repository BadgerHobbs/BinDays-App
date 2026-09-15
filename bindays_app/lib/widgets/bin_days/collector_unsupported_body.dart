// External Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';
import 'package:bindays_app/widgets/url_link.dart';

/// Inline failure state shown on the bin days screen when a location's
/// collector is no longer supported.
///
/// Rendered in the body so switching to a working address stays available.
class CollectorUnsupportedBody extends StatelessWidget {
  final SavedLocation location;

  const CollectorUnsupportedBody({super.key, required this.location});

  String _getEmailUrl(BuildContext context, String collectorName) {
    var subject = "BinDays Feedback";
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      subject += " (iOS)";
    } else if (platform == TargetPlatform.android) {
      subject += " (Android)";
    }
    final body =
        "[Please describe your issue or feedback here]\n\n---\n\nCollector: $collectorName";
    return "mailto:contact@bindays.app?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";
  }

  void _changeAddress(BuildContext context) {
    // Start a fresh setup that replaces this location's collector and address
    // in place, keeping its id and nickname.
    setupState.reset(editingLocationId: location.id);
    navigateToEnterPostcodePage(context);
  }

  @override
  Widget build(BuildContext context) {
    final collector = location.collector;

    final message =
        "Your council '${collector.name}' has changed their website in a "
        "way that has broken automatic bin day lookups (for example, adding "
        "new anti-bot protection).\n\n"
        "We're looking into a workaround, but can't provide a timeline for "
        "when, or if, support will be restored.\n\n"
        "We apologise for any inconvenience this causes.";

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
            'No Longer Supported',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          UrlLink(
            text: "Send feedback to contact@bindays.app",
            url: _getEmailUrl(context, collector.name),
          ),
          const SizedBox(height: 15),
          PrimaryButton(
            text: "Visit Council Website",
            onPressed: () => launchUrlString(collector.websiteUrl.toString()),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: "Change Address",
            onPressed: () => _changeAddress(context),
          ),
        ],
      ),
    );
  }
}
