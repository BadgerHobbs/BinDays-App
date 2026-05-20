/// Returns true if [error] is an HTTP 410 response, indicating the stored
/// collector version is out of date and the user must re-select their address.
bool isCollectorVersionOutdated(Object error) {
  try {
    final dynamic dynamicError = error;
    return dynamicError.response?.statusCode == 410;
  } catch (_) {
    return false;
  }
}
