// External Imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/notifications_page.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/widgets/url_link.dart';

class BinDayDrawer extends StatefulWidget {
  const BinDayDrawer({super.key});

  @override
  State<BinDayDrawer> createState() => _BinDayDrawerState();
}

class _BinDayDrawerState extends State<BinDayDrawer> {
  @override
  void initState() {
    super.initState();
    globalStateNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String _getEmailUrl() {
    var emailUrl = "mailto:contact@bindays.app?subject=BinDays Feedback";
    if (Platform.isIOS) {
      emailUrl += " (iOS)";
    } else if (Platform.isAndroid) {
      emailUrl += " (Android)";
    }
    return emailUrl;
  }

  @override
  Widget build(BuildContext context) {
    final address = globalStateNotifier.address!;
    final isDarkMode = globalStateNotifier.isDarkMode;

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25,
          top: 50,
          bottom: 25,
          right: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text(
              address.toFormattedString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 25),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.edit_location_alt_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Change Address",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () => navigateToEnterPostcodePage(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.notifications_active_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Notifications",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                isDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap:
                  () => {
                    globalStateNotifier.setIsDarkMode(
                      !globalStateNotifier.isDarkMode,
                    ),
                  },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.rate_review_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                "Send Feedback",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () => launchUrlString(_getEmailUrl()),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: UrlLink(
                    text: "Privacy Policy",
                    url: "https://bindays.app/privacy-policy.html",
                  ),
                ),
                Flexible(
                  child: UrlLink(
                    text: "Terms & Conditions",
                    url:
                        Platform.isIOS
                            ? "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
                            : "https://bindays.app/terms-and-conditions.html",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
