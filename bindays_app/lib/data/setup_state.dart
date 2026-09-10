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

  /// The id of the existing location being edited, if any.
  ///
  /// When null the setup flow adds a new location; when set the flow updates
  /// the existing location with that id in place (used by the "add another
  /// address" vs "re-select / change address" recovery flows).
  String? editingLocationId;

  /// Resets all setup state, ready for a fresh add or edit flow.
  ///
  /// Clears the leftover [editingLocationId] so a subsequent "add address"
  /// does not accidentally overwrite a previously edited location.
  void reset({String? editingLocationId}) {
    postcode = null;
    collector = null;
    addresses = null;
    this.editingLocationId = editingLocationId;
  }
}

final setupState = SetupState();
