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
      pageContent = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Finding upcoming collections",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(68, 68, 68, 1),
              ),
            ),
            AnimatedEllipsis(),
          ],
        ),
      );
    } else if (binDays!.isEmpty) {
      pageContent = const Text("No collections found");
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
      drawer: BinDayDrawer(address: globalStateNotifier.address!),
      appBar: AppBar(),
      body: SafeBasePage(child: pageContent),
    );
  }
}
