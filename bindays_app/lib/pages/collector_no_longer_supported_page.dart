// External Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/setup/generics/not_found_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';
import 'package:bindays_app/widgets/url_link.dart';

class CollectorNoLongerSupportedPage extends StatelessWidget {
  const CollectorNoLongerSupportedPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final collector = globalStateNotifier.collector!;
    final message =
        "Your council '${collector.name}' has changed their website in a "
        "way that has broken automatic bin day lookups (for example, adding "
        "new anti-bot protection).\n\n"
        "We're looking into a workaround, but can't provide a timeline for "
        "when, or if, support will be restored.\n\n"
        "We apologise for any inconvenience this causes.";

    return NotFoundPage(
      headline: "No Longer Supported",
      message: message,
      topLink: UrlLink(
        text: "Send feedback to contact@bindays.app",
        url: _getEmailUrl(context, collector.name),
      ),
      button: PrimaryButton(
        text: "Visit Council Website",
        onPressed: () => launchUrlString(collector.websiteUrl.toString()),
      ),
      extraButton: SecondaryButton(
        text: "Change Address",
        onPressed: () => navigateToEnterPostcodePage(context),
      ),
    );
  }
}
