// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/animated_ellipsis.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_drawer.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_groups.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_header.dart';

class BinDaysPage extends StatefulWidget {
  const BinDaysPage({super.key});

  @override
  State<BinDaysPage> createState() => _BinDaysPageState();
}

class _BinDaysPageState extends State<BinDaysPage> {
  List<BinDay>? binDays;

  @override
  void initState() {
    super.initState();
    _getBinDays();
  }

  Future<void> _getBinDays() async {
    try {
      final binDays = await binDaysClient.getBinDays(
        globalStateNotifier.collector!,
        globalStateNotifier.address!,
      );
      setState(() => this.binDays = binDays);
    } catch (e) {
      binDays = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort bin days by date asc
    binDays?.sort((a, b) => a.date.compareTo(b.date));

    Widget pageContent;
    if (binDays == null) {
      pageContent = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Finding upcoming collections",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const AnimatedEllipsis(),
          ],
        ),
      );
    } else if (binDays!.isEmpty) {
      pageContent = Text(
        "No collections found",
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      );
    } else {
      pageContent = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BinDayHeader(binDay: binDays!.first),
              const SizedBox(height: 25),
              BinDayGroups(binDays: binDays!),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      drawer: const BinDayDrawer(),
      appBar: AppBar(),
      body: SafeBasePage(child: pageContent),
    );
  }
}
