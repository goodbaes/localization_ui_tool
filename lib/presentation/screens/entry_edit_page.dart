import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';
import 'package:localization_ui_tool/presentation/widgets/error_dialog.dart';

class EntryEditPage extends StatefulWidget {
  final String entryKey;
  const EntryEditPage({super.key, required this.entryKey});

  @override
  State<EntryEditPage> createState() => _EntryEditPageState();
}

class _EntryEditPageState extends State<EntryEditPage> {
  final Map<String, TextEditingController> _controllers = {};
  late TextEditingController _keyController; // Controller for the key input
  LocalizationEntry? _currentEntry;
  SnackBar? _currentSnackBar; // To keep track of the displayed SnackBar

  // Define supported locales for displaying all translation fields
  final List<String> _supportedLocales = ['en', 'es']; // Add more locales as needed

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.entryKey);

    // If it's a new entry, initialize with empty values for all supported locales
    if (widget.entryKey.isEmpty) {
      _currentEntry = LocalizationEntry(key: '', values: {});
      for (var locale in _supportedLocales) {
        _controllers[locale] = TextEditingController();
      }
    } else {
      // For existing entries, load data from cubit
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = context.read<LocalizationCubit>().state;
        if (state is LocalizationLoaded) {
          _currentEntry = state.entries.firstWhere(
            (entry) => entry.key == widget.entryKey,
            orElse: () => LocalizationEntry(key: widget.entryKey, values: {}),
          );
          _keyController.text = _currentEntry!.key; // Set key controller text

          // Populate controllers for existing values and create for missing ones
          for (var locale in _supportedLocales) {
            _controllers[locale] = TextEditingController(text: _currentEntry!.values[locale] ?? '');
          }
          setState(() {}); // Rebuild to show initial values
        }
      });
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _controllers.forEach((key, controller) => controller.dispose());
    _currentSnackBar = null; // Clear snackbar reference
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_currentEntry == null) return;

    final String keyToSave = widget.entryKey.isEmpty ? _keyController.text : _currentEntry!.key;
    if (keyToSave.isEmpty) {
      ErrorDialog.show(context, context.l10n.keyCannotBeEmpty);
      return;
    }

    final updatedValues = <String, String>{};
    _controllers.forEach((locale, controller) {
      updatedValues[locale] = controller.text;
    });

    final updatedEntry = LocalizationEntry(
      key: keyToSave,
      values: updatedValues,
    );

    await context.read<LocalizationCubit>().updateEntry(updatedEntry);

    // The navigation logic is now handled in the BlocListener
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryKey.isEmpty ? context.l10n.addEntry : context.l10n.editEntry(widget.entryKey)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: BlocListener<LocalizationCubit, LocalizationState>(
        listener: (context, state) {
          // Dismiss any existing snackbar before showing a new one or handling state
          if (_currentSnackBar != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _currentSnackBar = null;
          }

          if (state is LocalizationSaving) {
            _currentSnackBar = SnackBar(content: Text(context.l10n.saving));
            ScaffoldMessenger.of(context).showSnackBar(_currentSnackBar!);
          } else if (state is LocalizationLoaded) {
            // Dismiss the saving snackbar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _currentSnackBar = null;

            // For new entries, pop after successful save, but defer to next frame
            if (widget.entryKey.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });
            } else {
              // Update _currentEntry if it was just saved and reloaded
              _currentEntry = state.entries.firstWhere(
                (entry) => entry.key == widget.entryKey,
                orElse: () => LocalizationEntry(key: widget.entryKey, values: {}),
              );
              _keyController.text = _currentEntry!.key;
              _currentEntry?.values.forEach((locale, text) {
                if (_controllers.containsKey(locale)) {
                  _controllers[locale]!.text = text;
                } else {
                  _controllers[locale] = TextEditingController(text: text);
                }
              });
              setState(() {});
            }
          } else if (state is LocalizationError) {
            // Dismiss the saving snackbar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _currentSnackBar = null;

            ErrorDialog.show(context, state.message);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (widget.entryKey.isEmpty) // Show key input only for new entries
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    labelText: context.l10n.key,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            ..._supportedLocales.map((locale) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _controllers[locale],
                  decoration: InputDecoration(
                    labelText: '${locale.toUpperCase()} ${context.l10n.translation}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}