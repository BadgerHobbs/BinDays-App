// External Imports
import 'package:bindays_client/models/bin_day.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

// Internal Imports
import 'package:bindays_app/data/location_refresh_service.dart';
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/shared_preferences_manager.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/bin_days/bin_days_found.dart';
import 'package:bindays_app/widgets/bin_days/bin_days_not_found.dart';
import 'package:bindays_app/widgets/bin_days/collector_outdated_body.dart';
import 'package:bindays_app/widgets/bin_days/collector_unsupported_body.dart';
import 'package:bindays_app/extensions/date_time_extension.dart';

/// A single swipeable page showing the bin days for one saved location, with
/// its own pull-to-refresh and failure handling.
class LocationBinDaysView extends StatefulWidget {
  final String locationId;

  const LocationBinDaysView({super.key, required this.locationId});

  @override
  State<LocationBinDaysView> createState() => _LocationBinDaysViewState();
}

class _LocationBinDaysViewState extends State<LocationBinDaysView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;
  final InAppReview _inAppReview = InAppReview.instance;

  /// The location this page renders, resolved fresh so mutations are seen.
  SavedLocation? get _location {
    for (final location in globalStateNotifier.locations) {
      if (location.id == widget.locationId) return location;
    }
    return null;
  }

  /// The upcoming (today or later) bin days for this location.
  List<BinDay>? get _upcomingBinDays => _location?.binDays
      ?.where((binDay) => binDay.date.isTodayOrAfter())
      .toList();

  @override
  void initState() {
    super.initState();
    // Only show the loading blank if this healthy location has nothing cached
    // yet; a broken location renders its failure body instead of refreshing.
    final binDays = _upcomingBinDays;
    final status = _location?.status ?? LocationStatus.ok;
    _isRefreshing =
        status == LocationStatus.ok && (binDays == null || binDays.isEmpty);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeRefresh();
    });
    globalStateNotifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    globalStateNotifier.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _onStateChanged() {
    setState(() {});
  }

  /// Refresh if this location has no cached bin days or hasn't refreshed today.
  /// A broken collector shows its cached failure state instead.
  void _maybeRefresh() {
    final location = _location;
    if (location == null) return;
    if (location.status != LocationStatus.ok) return;

    final binDays = _upcomingBinDays;
    final lastRefresh = location.lastRefresh;
    final binDaysFound = binDays != null && binDays.isNotEmpty;
    final lastRefreshToday =
        lastRefresh != null && DateUtils.isSameDay(lastRefresh, DateTime.now());

    if (!binDaysFound || !lastRefreshToday) {
      _refreshIndicatorKey.currentState?.show();
    } else {
      _checkAndRequestReview();
    }
  }

  Future<void> _getBinDays() async {
    final location = _location;
    if (location == null) return;

    setState(() {
      _isRefreshing = true;
    });
    try {
      final result = await LocationRefreshService.refreshLocation(location);

      if (result.status == LocationStatus.ok) {
        final binDays = result.binDays ?? const [];

        // If this is the first successful fetch, schedule a review request.
        final reviewAfter = SharedPreferencesManager.getRequestReviewAfter();
        if (reviewAfter == null && binDays.isNotEmpty) {
          final twoWeeksFromNow = DateTime.now().add(const Duration(days: 14));
          await SharedPreferencesManager.setRequestReviewAfter(twoWeeksFromNow);
        }
        _checkAndRequestReview();
      }

      // Reschedule notifications once for this refresh.
      globalStateNotifier.rescheduleNotifications();
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

  Widget _buildContent(SavedLocation location) {
    if (location.status == LocationStatus.outdated) {
      return CollectorOutdatedBody(location: location);
    }
    if (location.status == LocationStatus.unsupported) {
      return CollectorUnsupportedBody(location: location);
    }

    final binDays = _upcomingBinDays;
    binDays?.sort((a, b) => a.date.compareTo(b.date));

    final lastRefresh = location.lastRefresh;
    final binDaysFound =
        binDays != null && binDays.isNotEmpty && lastRefresh != null;

    return binDaysFound
        ? BinDaysFound(binDays: binDays, lastRefresh: lastRefresh)
        : const BinDaysNotFound();
  }

  @override
  Widget build(BuildContext context) {
    final location = _location;
    if (location == null) return const SizedBox();

    final binDays = _upcomingBinDays;
    final binDaysFound =
        binDays != null && binDays.isNotEmpty && location.lastRefresh != null;

    // Only show a blank screen while the first fetch for a healthy location is
    // in flight; failure states always render their body.
    final showBlankWhileLoading =
        _isRefreshing && !binDaysFound && location.status == LocationStatus.ok;

    return RefreshIndicator(
      backgroundColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.onPrimary,
      key: _refreshIndicatorKey,
      onRefresh: () => _getBinDays(),
      child: SafeBasePage(
        child:
            showBlankWhileLoading
                ? const SizedBox()
                : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildContent(location),
                ),
      ),
    );
  }
}
