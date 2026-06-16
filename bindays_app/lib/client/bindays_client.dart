// External Imports
import 'package:bindays_client/client.dart';

// Internal Imports
import 'package:bindays_app/client/client_with_retry.dart';
import 'package:bindays_app/client/native_transport.dart';

/// Builds the BinDays API client.
///
/// On mobile it uses the platform's native HTTP stack (Cronet on Android,
/// NSURLSession on iOS) so requests present a real browser TLS fingerprint —
/// required for councils behind a Cloudflare TLS-fingerprint challenge such as
/// Sunderland. If the native stack is unavailable (e.g. an Android device with
/// no Cronet provider) or on web/desktop, the default dart:io transport is kept.
Client _buildClient() {
  final client = Client(Uri.parse("https://api.bindays.app"));

  final nativeAdapter = createNativeAdapter();
  if (nativeAdapter != null) {
    client.httpClient.httpClientAdapter = nativeAdapter;
  }

  return client;
}

ClientWithRetry binDaysClient = ClientWithRetry(_buildClient());
