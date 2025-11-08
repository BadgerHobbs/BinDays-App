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
      final unsupportedDetails = _parseUnsupportedCollectorError(e);
      if (unsupportedDetails != null) {
        setupState.collector = null;
        if (mounted) {
          navigateToCollectorUnsupportedPage(
            context,
            pushReplacement: true,
            collectorName: unsupportedDetails.collectorName,
          );
        }
        return;
      }

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

  ({String? collectorName})? _parseUnsupportedCollectorError(Object error) {
    for (final message in _errorMessages(error)) {
      final trimmed = message.trim();
      if (trimmed.isEmpty) {
        continue;
      }

      final normalized = trimmed.toLowerCase();
      if (!normalized.contains('not currently supported')) {
        continue;
      }

      final match = RegExp(
        r'^(.*?) is not currently supported\.?$',
        caseSensitive: false,
      ).firstMatch(trimmed);

      final collectorName = match?.group(1)?.trim();
      return (
        collectorName:
            (collectorName != null && collectorName.isNotEmpty)
                ? collectorName
                : null,
      );
    }

    return null;
  }

  Iterable<String> _errorMessages(Object error) sync* {
    // Try to extract from DioException-like responses.
    try {
      final dynamic dynamicError = error;
      final response = dynamicError.response;
      final data = response?.data;

      if (data is String) {
        yield data;
      } else if (data is Map) {
        final message = data['message'] ?? data['Message'];
        if (message is String) {
          yield message;
        }
      }
    } catch (_) {
      // Ignore – fall back to string representation below.
    }

    yield error.toString();
  }
}
