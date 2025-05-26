// External Imports
import 'package:bindays_app/client/client_with_retry.dart';
import 'package:bindays_client/client.dart';

ClientWithRetry binDaysClient = ClientWithRetry(
  Client(Uri.parse("https://api.bindays.app")),
);
