// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_drawer_background.dart';

class BinDayDrawer extends StatelessWidget {
  final Address address;

  const BinDayDrawer({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
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
              Text(address.toFormattedString()),
              const SizedBox(height: 25),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.edit_location_alt_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Change Address"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.notifications_active_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Notifications"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.dark_mode_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Dark Mode"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.rate_review_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text("Send Feedback"),
              ),
              const Spacer(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(decoration: TextDecoration.underline),
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
