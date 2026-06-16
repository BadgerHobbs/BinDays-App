// External Imports
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
// native_dio_adapter re-exports CronetEngine (from cronet_http).
import 'package:native_dio_adapter/native_dio_adapter.dart';

/// Returns a native HTTP adapter for the current platform, or `null` to keep the
/// default dart:io transport.
///
/// - **iOS**: NSURLSession (always available on the platform).
/// - **Android**: Cronet, but only when a provider (Google Play Services) is
///   present. Building the engine eagerly surfaces an unavailable provider here,
///   so we can fall back to the default transport instead of breaking every
///   request on devices without Cronet.
/// - **Desktop**: `null` (default transport).
HttpClientAdapter? createNativeAdapter() {
  if (Platform.isIOS) {
    return NativeAdapter();
  }

  if (Platform.isAndroid) {
    try {
      final engine = CronetEngine.build();
      return NativeAdapter(createCronetEngine: () => engine);
    } catch (_) {
      // No Cronet provider (e.g. no Google Play Services) — keep the default
      // transport so non-Cloudflare councils still work.
      return null;
    }
  }

  return null;
}
