// External Imports
import 'package:dio/dio.dart';

// Platform-specific implementation: the dart:io version (mobile/desktop) pulls
// in native_dio_adapter/cronet_http; the web version is a no-op stub so the web
// build never imports dart:io-only packages.
import 'native_transport_io.dart'
    if (dart.library.html) 'native_transport_web.dart' as impl;

/// Returns the platform's native HTTP adapter (Cronet on Android, NSURLSession
/// on iOS) when available, or `null` to keep the default dart:io transport.
///
/// The native stacks present a real browser TLS fingerprint, which is required
/// for councils behind a Cloudflare TLS-fingerprint (JA3/JA4) challenge — e.g.
/// Sunderland — that block the non-browser dart:io fingerprint.
HttpClientAdapter? createNativeAdapter() => impl.createNativeAdapter();
