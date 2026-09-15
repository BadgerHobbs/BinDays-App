// External Imports
import 'package:flutter/material.dart';

// Internal Imports
import 'package:bindays_app/data/models/saved_location.dart';
import 'package:bindays_app/data/setup_state.dart';
import 'package:bindays_app/extensions/address_extension.dart';
import 'package:bindays_app/misc/navigators.dart';
import 'package:bindays_app/notifiers/global_notifiers.dart';
import 'package:bindays_app/pages/safe_base_page.dart';
import 'package:bindays_app/widgets/primary_button.dart';

class ManageAddressesPage extends StatefulWidget {
  const ManageAddressesPage({super.key});

  @override
  State<ManageAddressesPage> createState() => _ManageAddressesPageState();
}

class _ManageAddressesPageState extends State<ManageAddressesPage> {
  @override
  void initState() {
    super.initState();
    globalStateNotifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    globalStateNotifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _addAddress() {
    setupState.reset();
    navigateToEnterPostcodePage(context);
  }

  Future<void> _renameLocation(SavedLocation location) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _RenameAddressDialog(location: location),
    );

    // A null result means the dialog was dismissed without saving.
    if (newName != null) {
      globalStateNotifier.renameLocation(location.id, newName);
    }
  }

  Future<void> _deleteLocation(SavedLocation location) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Address'),
          content: Text(
            "Remove '${location.displayName}'? You can add it again later.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      globalStateNotifier.removeLocation(location.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = globalStateNotifier.locations;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Addresses')),
      body: SafeBasePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Drag to reorder how you swipe between addresses.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: locations.length,
                onReorder: globalStateNotifier.reorderLocations,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final hasNickname =
                      location.name != null && location.name!.trim().isNotEmpty;

                  return ListTile(
                    key: ValueKey(location.id),
                    contentPadding: EdgeInsets.zero,
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.drag_handle,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    title: Text(location.displayName),
                    subtitle: Text(
                      hasNickname
                          ? location.address.toFormattedString()
                          : location.address.postcode?.toUpperCase() ?? '',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Rename',
                          onPressed: () => _renameLocation(location),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Remove',
                          onPressed: () => _deleteLocation(location),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Add Address', onPressed: _addAddress),
          ],
        ),
      ),
    );
  }
}

/// Dialog for editing a location's nickname. Owns its [TextEditingController]
/// so it is disposed with the widget, after the route has been torn down.
class _RenameAddressDialog extends StatefulWidget {
  final SavedLocation location;

  const _RenameAddressDialog({required this.location});

  @override
  State<_RenameAddressDialog> createState() => _RenameAddressDialogState();
}

class _RenameAddressDialogState extends State<_RenameAddressDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.location.name ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Address'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: widget.location.address.toFormattedStringNoPostcode(),
          labelText: 'Nickname',
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
