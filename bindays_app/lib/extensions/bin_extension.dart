// External Imports
import 'package:bindays_client/models/bin.dart';

extension BinExtension on Bin {
  /// Returns the bin colour and container type, e.g. "Brown Caddy".
  String toTypeString() {
    return "${colour.trim()} ${(type ?? "Bin").trim()}";
  }
}
