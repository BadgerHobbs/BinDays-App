// External Imports
import 'package:bindays_app/misc/navigators.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/notifications_page.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_drawer_background.dart';

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
  Widget build(BuildContext context) {
    final address = globalStateNotifier.address!;
    final isDarkMode = globalStateNotifier.isDarkMode;

    return Drawer(
      child: BinDayDrawerBackground(
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
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
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
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
