// External Imports
import 'package:bindays_app/widgets/animated_ellipsis.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_drawer.dart';
import 'package:bindays_client/models/address.dart';
import 'package:bindays_client/models/bin_day.dart';
import 'package:bindays_client/models/collector.dart';
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/client/bindays_client.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_groups.dart';
import 'package:bindays_app/widgets/bin_days/bin_day_header.dart';

class BinDaysPage extends StatefulWidget {
  final String postcode;
  final Collector collector;
  final Address address;

  const BinDaysPage({
    super.key,
    required this.postcode,
    required this.collector,
    required this.address,
  });

  @override
  State<BinDaysPage> createState() => _BinDaysPageState();
}

class _BinDaysPageState extends State<BinDaysPage> {
  List<BinDay>? binDays;

  @override
  void initState() {
    super.initState();
    _getBinDays();
  }

  Future<void> _getBinDays() async {
    try {
      final binDays = await binDaysClient.getBinDays(
        widget.collector,
        widget.address,
      );
      setState(() => this.binDays = binDays);
    } catch (e) {
      binDays = [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort bin days by date asc
    binDays?.sort((a, b) => a.date.compareTo(b.date));

    Widget pageContent;
    if (binDays == null) {
      pageContent = Center(child: AnimatedEllipsis());
    } else if (binDays!.isEmpty) {
      pageContent = Text("No collections found");
    } else {
      pageContent = SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                    BinDayHeader(binDay: binDays!.first),
                    BinDayGroups(binDays: binDays!),
                  ]
                  .map(
                    (e) =>
                        Padding(padding: EdgeInsets.only(bottom: 25), child: e),
                  )
                  .toList(),
        ),
      );
    }

    return Scaffold(
      drawer: BinDayDrawer(),
      appBar: AppBar(
        title: Text(widget.address.toFormattedString()),
        elevation: 0,
      ),
      body: SafeArea(minimum: EdgeInsets.all(25), child: pageContent),
    );
  }
}
