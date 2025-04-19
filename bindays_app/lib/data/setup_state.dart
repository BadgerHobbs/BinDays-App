// External Imports
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/collector.dart';

class SetupState {
  /// The postcode entered by the user.
  String? postcode;

  /// The collector selected by the user.
  Collector? collector;

  /// The addresses found for the selected collector and postcode.
  List<Address>? addresses;
}

final setupState = SetupState();
