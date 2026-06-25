// External Imports
import 'package:flutter/material.dart';
// Internal Imports
import 'package:bindays_app/misc/issue_type.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';
import 'package:bindays_app/widgets/secondary_button.dart';
import 'package:bindays_app/widgets/url_link.dart';


class VerifyCouncilPage extends StatelessWidget {
  final IssueType issueType;

  const VerifyCouncilPage({super.key, required this.issueType});

  @override
  Widget build(BuildContext context) {
    final websiteUrl = globalStateNotifier.collector?.websiteUrl;

    return Scaffold(
      appBar: AppBar(title: const Text("Before You Report")),
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
                      "BinDays pulls its data directly from your council's website. If the council site is down or out of date, that'll affect BinDays too.",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Around bank holidays, councils often change their collection schedules without updating their website straight away.",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Please check that your council's website is showing the correct information before reporting an issue with BinDays.",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (websiteUrl != null) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: UrlLink(
                          text: "Visit ${globalStateNotifier.collector?.name ?? 'council'} website",
                          url: websiteUrl.toString(),
                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: "Council website is correct",
              onPressed: () => navigateToReportIssuePage(
                context,
                issueType: issueType,
                councilWebsiteWorking: true,
              ),
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              text: "Council website has a problem",
              onPressed: () => navigateToReportIssuePage(
                context,
                issueType: issueType,
                councilWebsiteWorking: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
