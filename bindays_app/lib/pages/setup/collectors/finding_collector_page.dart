// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/setup/generics/loading_page.dart';

class FindingCollectorPage extends StatefulWidget {
  const FindingCollectorPage({super.key});

  @override
  State<FindingCollectorPage> createState() => _FindingCollectorPage();
}

class _FindingCollectorPage extends State<FindingCollectorPage> {
  @override
  void initState() {
    super.initState();
    _getCollector();
  }

  Future<void> _getCollector() async {
    try {
      setupState.collector = await binDaysClient.getCollector(
        setupState.postcode!,
      );
      if (mounted) {
        navigateToConfirmCollectorPage(context, pushReplacement: true);
      }
    } catch (e) {
      if (mounted) {
        navigateToCollectorNotFoundPage(context, pushReplacement: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage(
      titleText: "Finding Your Collector",
      descriptionText:
          "Please wait while we check which bin collector serves your area. This may take a few seconds.",
    );
  }
}
