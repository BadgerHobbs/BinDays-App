// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/issue_type.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';

class TroubleshootingPage extends StatelessWidget {
  const TroubleshootingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Troubleshooting")),
      body: SafeBasePage(
        child: ListView(
          children: [
            Text(
              "What's the problem?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Can't find my address"),
              subtitle: const Text(
                'No addresses appeared when searching your postcode.',
              ),
              onTap: () => navigateToVerifyCouncilPage(
                context,
                issueType: IssueType.addressNotFound,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('No bin collections showing'),
              subtitle: const Text(
                'Address found, but no upcoming collections are listed.',
              ),
              onTap: () => navigateToVerifyCouncilPage(
                context,
                issueType: IssueType.noBinCollectionsFound,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Wrong or missing bin dates'),
              subtitle: const Text(
                "Dates, bin types, or colours don't match what you'd expect.",
              ),
              onTap: () => navigateToVerifyCouncilPage(
                context,
                issueType: IssueType.incorrectOrMissingBins,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Bins weren't collected"),
              subtitle: const Text(
                'Your council did not collect your bins.',
              ),
              onTap: () => navigateToBinsNotCollectedPage(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Something else'),
              subtitle: const Text("My problem isn't listed here."),
              onTap: () => navigateToReportIssuePage(
                context,
                issueType: IssueType.somethingElse,
                councilWebsiteWorking: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
