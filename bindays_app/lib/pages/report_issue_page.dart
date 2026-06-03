// External Imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/misc/issue_type.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';

class ReportIssuePage extends StatelessWidget {
  final IssueType issueType;
  final bool? councilWebsiteWorking;

  const ReportIssuePage({
    super.key,
    required this.issueType,
    required this.councilWebsiteWorking,
  });

  String _getEmailUrl(BuildContext context) {
    var subject = "BinDays Issue Report";
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      subject += " (iOS)";
    } else if (platform == TargetPlatform.android) {
      subject += " (Android)";
    }
    final issue = issueType.displayName;
    final councilStatus = switch (councilWebsiteWorking) {
      true => 'Working',
      false => 'Has an issue',
      null => 'N/A',
    };
    final collector = globalStateNotifier.collector?.name ?? "Not set";
    final address =
        globalStateNotifier.address?.toFormattedString() ?? "Not set";
    final body =
        "[Please describe your issue here]\n\n---\n\nIssue: $issue\nCouncil website: $councilStatus\nCollector: $collector\nAddress: $address";
    return "mailto:contact@bindays.app?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    try {
      final launched = await launchUrlString(urlString);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report an Issue")),
      body: SafeBasePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thanks for confirming. Please include as much of the following as you can to help us look into it quickly.",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...[
                      "What the problem is and when you first noticed it.",
                      "What BinDays is currently showing (dates, bin types, colours).",
                      "What you expected to see, or what your council's website shows.",
                      "Whether the issue affects all collections or just specific ones.",
                      "Your postcode and council name, if not already included.",
                    ].map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "•  ",
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.bodyLarge!.fontSize,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.fontSize,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: "Send an Email",
              onPressed: () => _launchUrl(context, _getEmailUrl(context)),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              text: "Open a GitHub Issue",
              onPressed: () => _launchUrl(
                context,
                "https://github.com/BadgerHobbs/BinDays-App/issues/new",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
