// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/misc/issue_type.dart';
import 'package:bindays_app/pages/bin_days_page.dart';
import 'package:bindays_app/pages/collector_outdated_page.dart';
import 'package:bindays_app/pages/report_issue_page.dart';
import 'package:bindays_app/pages/troubleshooting_page.dart';
import 'package:bindays_app/pages/setup/addresses/addresses_not_found_page.dart';
import 'package:bindays_app/pages/setup/addresses/finding_addresses_page.dart';
import 'package:bindays_app/pages/setup/addresses/select_address_page.dart';
import 'package:bindays_app/pages/setup/collectors/collector_not_found_page.dart';
import 'package:bindays_app/pages/setup/collectors/collector_unsupported_page.dart';
import 'package:bindays_app/pages/setup/collectors/confirm_collector_page.dart';
import 'package:bindays_app/pages/setup/collectors/finding_collector_page.dart';
import 'package:bindays_app/pages/setup/collectors/request_council_page.dart';
import 'package:bindays_app/pages/setup/collectors/select_collector_page.dart';
import 'package:bindays_app/pages/setup/enter_postcode_page.dart';
import 'package:bindays_app/pages/bins_not_collected_page.dart';
import 'package:bindays_app/pages/setup/how_it_works_page.dart';
import 'package:bindays_app/pages/settings_page.dart';
import 'package:bindays_app/pages/notifications_page.dart';
import 'package:bindays_app/pages/verify_council_page.dart';

/// Navigates to the HowItWorksPage.
void navigateToHowItWorksPage(BuildContext context) {
  _navigateToPage(context, const HowItWorksPage());
}

/// Navigates to the EnterPostcodePage.
void navigateToEnterPostcodePage(BuildContext context) {
  _navigateToPage(context, const EnterPostcodePage());
}

/// Navigates to the FindingCollectorPage.
void navigateToFindingCollectorPage(BuildContext context) {
  _navigateToPage(context, const FindingCollectorPage());
}

/// Navigates to the ConfirmCollectorPage.
void navigateToConfirmCollectorPage(
  BuildContext context, {
  bool pushReplacement = false,
}) {
  _navigateToPage(
    context,
    const ConfirmCollectorPage(),
    pushReplacement: pushReplacement,
  );
}

/// Navigates to the SelectCollectorPage.
void navigateToSelectCollectorPage(BuildContext context) {
  _navigateToPage(context, const SelectCollectorPage());
}

/// Navigates to the CollectorNotFoundPage.
void navigateToCollectorNotFoundPage(
  BuildContext context, {
  bool pushReplacement = false,
}) {
  _navigateToPage(
    context,
    const CollectorNotFoundPage(),
    pushReplacement: pushReplacement,
  );
}

/// Navigates to the RequestCouncilPage.
void navigateToRequestCouncilPage(BuildContext context) {
  _navigateToPage(context, const RequestCouncilPage());
}

/// Navigates to the CollectorUnsupportedPage.
void navigateToCollectorUnsupportedPage(
  BuildContext context, {
  bool pushReplacement = false,
  String? collectorName,
}) {
  _navigateToPage(
    context,
    CollectorUnsupportedPage(collectorName: collectorName),
    pushReplacement: pushReplacement,
  );
}

/// Navigates to the FindingAddressesPage.
void navigateToFindingAddressesPage(BuildContext context) {
  _navigateToPage(context, const FindingAddressesPage());
}

/// Navigates to the SelectAddressPage.
void navigateToSelectAdressPage(
  BuildContext context, {
  bool pushReplacement = false,
}) {
  _navigateToPage(
    context,
    const SelectAddressPage(),
    pushReplacement: pushReplacement,
  );
}

/// Navigates to the AddressesNotFoundPage.
void navigateToAddressNotFoundPage(
  BuildContext context, {
  bool pushReplacement = false,
}) {
  _navigateToPage(
    context,
    const AddressesNotFoundPage(),
    pushReplacement: pushReplacement,
  );
}

/// Navigates to the CollectorOutdatedPage.
void navigateToCollectorOutdatedPage(
  BuildContext context, {
  bool pushReplacement = false,
}) {
  _navigateToPage(
    context,
    const CollectorOutdatedPage(),
    pushReplacement: pushReplacement,
  );
}

/// Navigates to the BinDaysPage.
void navigateToBinDaysPage(BuildContext context) {
  _navigateToPage(context, const BinDaysPage());
}

/// Navigate to SettingsPage.
void navigateToSettingsPage(BuildContext context) {
  _navigateToPage(context, const SettingsPage());
}

/// Navigate to NotificationsPage.
void navigateToNotificationsPage(BuildContext context) {
  _navigateToPage(context, const NotificationsPage());
}

/// Navigate to TroubleshootingPage.
void navigateToTroubleshootingPage(BuildContext context) {
  _navigateToPage(context, const TroubleshootingPage());
}

/// Navigate to BinsNotCollectedPage.
void navigateToBinsNotCollectedPage(BuildContext context) {
  _navigateToPage(context, const BinsNotCollectedPage());
}

/// Navigate to VerifyCouncilPage.
void navigateToVerifyCouncilPage(
  BuildContext context, {
  required IssueType issueType,
}) {
  _navigateToPage(context, VerifyCouncilPage(issueType: issueType));
}

/// Navigate to ReportIssuePage.
void navigateToReportIssuePage(
  BuildContext context, {
  required IssueType issueType,
  required bool? councilWebsiteWorking,
}) {
  _navigateToPage(
    context,
    ReportIssuePage(
      issueType: issueType,
      councilWebsiteWorking: councilWebsiteWorking,
    ),
  );
}

/// Navigates to a specified page.
void _navigateToPage(
  BuildContext context,
  Widget page, {
  bool pushReplacement = false,
}) {
  if (pushReplacement) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
