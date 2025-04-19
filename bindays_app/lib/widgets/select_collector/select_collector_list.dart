// External Imports
import 'package:flutter/material.dart';
import 'package:bindays_client/models/collector.dart';

class SelectCollectorList extends StatelessWidget {
  final List<Collector>? collectors;
  final Collector? selectedCollector;
  final Function(Collector) onCollectorSelected;

  const SelectCollectorList({
    super.key,
    required this.collectors,
    required this.selectedCollector,
    required this.onCollectorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: ListView.builder(
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: collectors?.length ?? 0,
            itemBuilder: (context, index) {
              final collector = collectors![index];
              final isSelectedCollector = collector == selectedCollector;

              return Opacity(
                opacity: isSelectedCollector ? 1 : 0.5,
                child: ListTile(
                  onTap: () {
                    onCollectorSelected(collector);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    collector.name,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  leading: Icon(
                    Icons.place,
                    size: 25,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  trailing:
                      isSelectedCollector
                          ? Text(
                            "Selected",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                          : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
