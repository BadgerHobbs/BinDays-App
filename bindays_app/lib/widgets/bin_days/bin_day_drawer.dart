// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/widgets/bin_days/bin_day_drawer_background.dart';

class BinDayDrawer extends StatelessWidget {
  const BinDayDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BinDayDrawerBackground(
        child: Padding(
          padding: EdgeInsets.only(left: 25, top: 50, bottom: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.edit_location_alt_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text("Change Address"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.notifications_active_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text("Notifications"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.dark_mode_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text("Dark Mode"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.rate_review_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text("Send Feedback"),
              ),
              Spacer(),
              Row(
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
