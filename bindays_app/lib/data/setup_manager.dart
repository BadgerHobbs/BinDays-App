// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/collector.dart';

// Internal Imports
import 'package:bindays_app/client/bindays_client.dart';

class SetupManager {
  /// The postcode entered by the user.
  String? postcode;

  /// The collector selected by the user.
  Collector? collector;

  /// The addresses found for the selected collector and postcode.
  List<Address>? addresses;

  /// Retrieves the collector for the given postcode.
  Future<void> getCollector() async {
    collector = await binDaysClient.getCollector(postcode!);
  }

  /// Retrieves the addresses for the given collector and postcode.
  Future<void> getAddresses() async {
    addresses = await binDaysClient.getAddresses(collector!, postcode!);
  }
}

final setupManager = SetupManager();
