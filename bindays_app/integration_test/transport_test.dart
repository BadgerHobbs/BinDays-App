// On-device regression test for the libcurl-impersonate transport. Each case
// exercises a property the transport must preserve:
//   West Devon (EX20 1ZF): incomplete cert chain -> needs VERIFYPEER=0.
//   Sunderland (SR4 7NR): Cloudflare TLS-fingerprint challenge -> needs Chrome JA3.
//   Southampton (SO15 5NR): plain control.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bindays_app/client/bindays_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> check(String label, String postcode) async {
    final collector = await binDaysClient.getCollector(postcode);
    final addresses = await binDaysClient.getAddresses(collector, postcode);
    // ignore: avoid_print
    print('$label ($postcode): ${addresses.length} addresses');
    expect(addresses, isNotEmpty, reason: '$label returned no addresses');
  }

  testWidgets('West Devon (incomplete cert chain)', (_) async {
    await check('West Devon', 'EX20 1ZF');
  });

  testWidgets('Sunderland (Cloudflare challenge)', (_) async {
    await check('Sunderland', 'SR4 7NR');
  });

  testWidgets('Southampton (control)', (_) async {
    await check('Southampton', 'SO15 5NR');
  });
}
