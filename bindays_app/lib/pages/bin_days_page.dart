// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_drawer.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_groups.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_header.dart';
import 'package:intl/intl.dart';

class BinDaysPage extends StatefulWidget {
  const BinDaysPage({super.key});

  @override
  State<BinDaysPage> createState() => _BinDaysPageState();
}

class _BinDaysPageState extends State<BinDaysPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> _getBinDays() async {
    final binDays = await binDaysClient.getBinDays(
      globalStateNotifier.collector!,
      globalStateNotifier.address!,
    );
    globalStateNotifier.setBinDays(binDays);
    globalStateNotifier.setLastRefresh(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // Sort bin days by date asc
    final binDays = globalStateNotifier.binDays;
    binDays?.sort((a, b) => a.date.compareTo(b.date));

    final lastRefresh = globalStateNotifier.lastRefresh;

    Widget pageContent;
    if (binDays == null || binDays.isEmpty) {
      pageContent = Center(
        child: Text(
          "No bin collections found.\nPull down to refresh.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    } else {
      pageContent = Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BinDayHeader(binDay: binDays.first),
            const SizedBox(height: 25),
            BinDayGroups(binDays: binDays),
            const SizedBox(height: 25),
            if (lastRefresh != null)
              Text(
                "Refreshed on ${DateFormat("dd/MM/yyyy").format(lastRefresh)} at ${DateFormat("HH:mm").format(lastRefresh)}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: const BinDayDrawer(),
      appBar: AppBar(),
      body: SafeBasePage(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () => _getBinDays(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: pageContent,
            ),
          ),
        ),
      ),
    );
  }
}
