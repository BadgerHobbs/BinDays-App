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

              return ListTile(
                onTap: () {
                  onCollectorSelected(collector);
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.place,
                  size: 25,
                  color:
                      isSelectedCollector
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                title: Text(
                  collector.name,
                  style: TextStyle(
                    fontWeight:
                        isSelectedCollector
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        isSelectedCollector
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
