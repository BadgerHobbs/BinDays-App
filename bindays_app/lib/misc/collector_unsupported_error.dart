/// Message returned by the BinDays API when the collector for a govUkId has
/// been removed (e.g. the council's website changed in a way that broke
/// scraping entirely, and support has since been retired).
const _collectorNotSupportedMessage =
    "No supported collector found for the specified gov.uk ID.";

/// Returns true if [error] is an HTTP 404 response with the exact message the
/// API returns when a previously-supported collector has been removed,
/// indicating the council is no longer supported.
bool isCollectorNoLongerSupported(Object error) {
  try {
    final dynamic dynamicError = error;
    if (dynamicError.response?.statusCode != 404) {
      return false;
    }
    final data = dynamicError.response?.data;
    return data is String && data.trim() == _collectorNotSupportedMessage;
  } catch (_) {
    return false;
  }
}
