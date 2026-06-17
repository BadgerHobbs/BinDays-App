// External Imports
import 'package:bindays_client/client.dart';

// Internal Imports
import 'package:bindays_app/client/client_with_retry.dart';

/// Builds the BinDays API client.
///
/// [Client] defaults to the libcurl-impersonate transport (via dart:ffi), which
/// reproduces a real Chrome TLS ClientHello (JA3/JA4) and HTTP/2 fingerprint.
/// This is required for councils behind a Cloudflare TLS-fingerprint challenge
/// (e.g. Sunderland), and — with certificate validation disabled — also
/// tolerates the incomplete certificate chains some councils and the BinDays
/// API serve (e.g. West Devon). It is the same transport the BinDays-API
/// integration tests use, so the client and tests share one code path.
ClientWithRetry binDaysClient =
    ClientWithRetry(Client(Uri.parse("https://api.bindays.app")));
