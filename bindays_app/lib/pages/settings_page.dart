// External Imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
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
    var subject = "BinDays Feedback";
    if (Platform.isIOS) {
      subject += " (iOS)";
    } else if (Platform.isAndroid) {
      subject += " (Android)";
    }
    final collector = globalStateNotifier.collector?.name ?? "Not set";
    final address =
        globalStateNotifier.address?.toFormattedString() ?? "Not set";
    final body =
        "[Please describe your issue or feedback here]\n\n---\n\nCollector: $collector\nAddress: $address";
    return "mailto:contact@bindays.app?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}";
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
              title: const Text('Change Address'),
              subtitle: Text(
                "Change the address to get the latest bin collections for. Your current address is '${globalStateNotifier.address!.toFormattedString()}'.",
              ),
              onTap: () => navigateToEnterPostcodePage(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Manage Notifications'),
              subtitle: const Text(
                'Configure notifications for upcoming bin collections.',
              ),
              onTap: () => navigateToNotificationsPage(context),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: globalStateNotifier.isDarkMode,
              onChanged: (val) => globalStateNotifier.setIsDarkMode(val),
              title: const Text('Dark Mode'),
              subtitle: const Text(
                'Enable a dark theme across the application.',
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: globalStateNotifier.showBinTypeIcons,
              onChanged: (val) => globalStateNotifier.setShowBinTypeIcons(val),
              title: const Text('Show Bin Type Icons'),
              subtitle: const Text(
                'Show bin type icons instead of the default icon.',
              ),
            ),
            const SizedBox(height: 20),
            Text('Source Code', style: Theme.of(context).textTheme.titleMedium),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('App Source Code'),
              subtitle: const Text(
                'Explore the Flutter app code on GitHub. Report app bugs or suggest features here.',
              ),
              onTap:
                  () => launchUrlString(
                    "https://github.com/BadgerHobbs/BinDays-App",
                  ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('API Source Code'),
              subtitle: const Text(
                'View the back-end API code on GitHub. This service fetches bin collection data from councils/collectors.',
              ),
              onTap:
                  () => launchUrlString(
                    "https://github.com/BadgerHobbs/BinDays-API",
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              'User Feedback',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Rate This App'),
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
                'Have other feedback or questions? Send us an email directly at contact@bindays.app.',
              ),
              onTap: () => launchUrlString(_getEmailUrl()),
            ),
            const SizedBox(height: 20),
            Text(
              'Legal & Policies',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Privacy Policy'),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
