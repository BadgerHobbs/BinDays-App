// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_drawer.dart';
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
      _refreshIndicatorKey.currentState?.show();
    });
    globalStateNotifier.addListener(() {
      setState(() {});
    });
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
    } catch (e) {
      globalStateNotifier.setBinDays([]);
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
      drawer: const BinDayDrawer(),
      appBar: AppBar(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _getBinDays(),
        child: SafeBasePage(
          child:
              _isRefreshing
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
