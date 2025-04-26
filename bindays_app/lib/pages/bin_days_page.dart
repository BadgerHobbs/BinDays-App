// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/bin_days/bin_days_found.dart';
import 'package:bindays_app/widgets/bin_days/bin_days_not_found.dart';

class BinDaysPage extends StatefulWidget {
  const BinDaysPage({super.key});

  @override
  State<BinDaysPage> createState() => _BinDaysPageState();
}

class _BinDaysPageState extends State<BinDaysPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _isRefreshing =
        globalStateNotifier.binDays == null ||
        globalStateNotifier.binDays!.isEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only refresh on load if hasn't been refreshed today
      // and and no bin days have been previously found.
      final binDays = globalStateNotifier.binDays;
      final lastRefresh = globalStateNotifier.lastRefresh;
      final binDaysFound = binDays != null && binDays.isNotEmpty;
      final lastRefreshToday =
          lastRefresh != null && lastRefresh.day == DateTime.now().day;
      if (!binDaysFound || !lastRefreshToday) {
        _refreshIndicatorKey.currentState?.show();
      }
    });
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

  Future<void> _getBinDays() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      final binDays = await binDaysClient.getBinDays(
        globalStateNotifier.collector!,
        globalStateNotifier.address!,
      );
      globalStateNotifier.setBinDays(binDays);
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
    globalStateNotifier.setLastRefresh(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // Sort bin days by date asc
    final binDays = globalStateNotifier.binDays;
    binDays?.sort((a, b) => a.date.compareTo(b.date));

    final lastRefresh = globalStateNotifier.lastRefresh;

    final binDaysFound =
        binDays != null && binDays.isNotEmpty && lastRefresh != null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => navigateToSettingsPage(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimary,
        key: _refreshIndicatorKey,
        onRefresh: () => _getBinDays(),
        child: SafeBasePage(
          child:
              _isRefreshing && !binDaysFound
                  ? const SizedBox()
                  : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child:
                        binDaysFound
                            ? BinDaysFound(
                              binDays: binDays,
                              lastRefresh: lastRefresh,
                            )
                            : const BinDaysNotFound(),
                  ),
        ),
      ),
    );
  }
}
