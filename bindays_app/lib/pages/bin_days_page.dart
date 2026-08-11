// External Imports
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/misc/collector_unsupported_error.dart';
import 'package:bindays_app/misc/collector_version_error.dart';
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
  final InAppReview _inAppReview = InAppReview.instance;

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
      // Check/request review if bin days loaded from cache
      else {
        _checkAndRequestReview();
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

      // If this is the first successful fetch, schedule a review request.
      final reviewAfter = SharedPreferencesManager.getRequestReviewAfter();
      if (reviewAfter == null && binDays.isNotEmpty) {
        final twoWeeksFromNow = DateTime.now().add(const Duration(days: 14));
        await SharedPreferencesManager.setRequestReviewAfter(twoWeeksFromNow);
      }
      _checkAndRequestReview();
      globalStateNotifier.setLastRefresh(DateTime.now());
    } catch (e) {
      if (isCollectorVersionOutdated(e) && mounted) {
        navigateToCollectorOutdatedPage(context);
      } else if (isCollectorNoLongerSupported(e) && mounted) {
        navigateToCollectorNoLongerSupportedPage(context);
      } else {
        rethrow;
      }
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _checkAndRequestReview() async {
    final requestReviewAfter = SharedPreferencesManager.getRequestReviewAfter();

    if (requestReviewAfter?.isBefore(DateTime.now()) ?? false) {
      if (await _inAppReview.isAvailable()) {
        _inAppReview.requestReview();
        await SharedPreferencesManager.setRequestReviewAfter(DateTime(9999));
      }
    }
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
        leading: IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => navigateToTroubleshootingPage(context),
        ),
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
