// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/url_link.dart';

class BinsNotCollectedPage extends StatelessWidget {
  const BinsNotCollectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final collector = globalStateNotifier.collector;
    final websiteUrl = collector?.websiteUrl;

    final bodyStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Bins Weren't Collected")),
      body: SafeBasePage(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sorry to hear your bins weren't collected.",
                style: bodyStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "BinDays only shows your council's published schedule. It isn't affiliated with your council and can't chase up a missed collection.",
                style: bodyStyle,
              ),
              const SizedBox(height: 12),
              Text(
                "Your council is responsible for collecting your bins, so please report any missed collection to them directly.",
                style: bodyStyle,
              ),
              if (websiteUrl != null) ...[
                const SizedBox(height: 16),
                Center(
                  child: UrlLink(
                    text: "Visit ${collector?.name ?? 'council'} website",
                    url: websiteUrl.toString(),
                    fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
