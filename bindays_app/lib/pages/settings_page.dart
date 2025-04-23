// External Imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
      ),
      body: SafeBasePage(
        child: ListView(
          children: [
            Text('General', style: Theme.of(context).textTheme.titleMedium),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Change address'),
              subtitle: const Text(
                'Change the address to get the latest bin collections for.',
              ),
              onTap: () => navigateToEnterPostcodePage(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Manage notifications'),
              subtitle: const Text(
                'Configure notifications for upcoming bin collections.',
              ),
              onTap: () => navigateToNotificationsPage(context),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: globalStateNotifier.isDarkMode,
              onChanged: (val) => globalStateNotifier.setIsDarkMode(val),
              title: const Text('Dark mode'),
              subtitle: const Text(
                'Enable a dark theme across the application.',
              ),
            ),
            const SizedBox(height: 20),
            Text('Links', style: Theme.of(context).textTheme.titleMedium),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Rate this app'),
              subtitle: const Text(
                'Enjoying the app? Take a moment to rate it on the store.',
              ),
              onTap:
                  () => launchUrlString(
                    Platform.isIOS
                        ? "https://apps.apple.com/gb/app/bindays/id1602874224?platform=iphone"
                        : "https://play.google.com/store/apps/details?id=com.bindays.app.release",
                  ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Send Feedback'),
              subtitle: const Text(
                'Have a suggestion or found a issue? Let us know!',
              ),
              onTap: () => launchUrlString(_getEmailUrl()),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Privacy policy'),
              subtitle: const Text('View the app\'s privacy policy.'),
              onTap:
                  () => launchUrlString(
                    "https://bindays.app/privacy-policy.html",
                  ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Terms & Conditions'),
              subtitle: const Text('View the app\'s terms and conditions.'),
              onTap:
                  () => launchUrlString(
                    Platform.isIOS
                        ? "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
                        : "https://bindays.app/terms-and-conditions.html",
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
