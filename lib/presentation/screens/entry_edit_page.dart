import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/models/session_key.dart';
import 'package:localization_ui_tool/core/use_cases/get_supported_locales_use_case.dart';
import 'package:localization_ui_tool/core/utils/arb_validator.dart';
import 'package:localization_ui_tool/l10n/arb/app_localizations.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';
import 'package:localization_ui_tool/presentation/widgets/error_dialog.dart';

class EntryEditPage extends StatefulWidget {
  const EntryEditPage({required this.entryKey, required this.initialStatus, super.key});
  final String entryKey;
  final SessionKeyStatus initialStatus;

  @override
  State<EntryEditPage> createState() => _EntryEditPageState();
}

class _EntryEditPageState extends State<EntryEditPage> {
  final Map<String, TextEditingController> _controllers = {};
  late TextEditingController _keyController; // Controller for the key input
  LocalizationEntry? _currentEntry;
  SnackBar? _currentSnackBar; // To keep track of the displayed SnackBar
  String? _savedKey;
  List<Locale> _supportedLocales = []; // Dynamically loaded locales
  bool _isLoadingLocales = true;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.entryKey);
    _loadSupportedLocalesAndEntry();
  }

  Future<void> _loadSupportedLocalesAndEntry() async {
    try {
      final getSupportedLocales = GetIt.instance<GetSupportedLocalesUseCase>();
      final locales = await getSupportedLocales();
      setState(() {
        _supportedLocales = locales;
        _isLoadingLocales = false;
      });

      // If it's a new entry, initialize with empty values for all supported locales
      if (widget.entryKey.isEmpty) {
        _currentEntry = const LocalizationEntry(key: '', values: {});
        for (final locale in _supportedLocales) {
          _controllers[locale.languageCode] = TextEditingController();
        }
      } else {
        // For existing entries, load data from cubit
        final state = context.read<LocalizationCubit>().state;
        if (state is LocalizationLoaded) {
          _currentEntry = state.entries.firstWhere(
            (entry) => entry.key == widget.entryKey,
            orElse: () => LocalizationEntry(key: widget.entryKey, values: {}),
          );
          _keyController.text = _currentEntry!.key; // Set key controller text

          // Populate controllers for existing values and create for missing ones
          for (final locale in _supportedLocales) {
            _controllers[locale.languageCode] = TextEditingController(text: _currentEntry!.values[locale.languageCode] ?? '');
          }
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingLocales = false;
      });
      ErrorDialog.show(context, 'Failed to load locales: $e', error: e);
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

    final keyToSave = widget.entryKey.isEmpty ? _keyController.text : _currentEntry!.key;

    // Validate key
    final keyValidationError = ArbValidator.validateKey(context, keyToSave);
    if (keyValidationError != null) {
      ErrorDialog.show(context, keyValidationError, error: null);
      return;
    }

    final updatedValues = <String, String>{};
    for (final locale in _supportedLocales) {
      final value = _controllers[locale.languageCode]?.text ?? '';
      final valueValidationError = ArbValidator.validateValue(context, value);
      if (valueValidationError != null) {
        ErrorDialog.show(context, '${locale.languageCode.toUpperCase()}: $valueValidationError', error: null);
        return;
      }
      updatedValues[locale.languageCode] = value;
    }

    final updatedEntry = LocalizationEntry(
      key: keyToSave,
      values: updatedValues,
    );

    await context.read<LocalizationCubit>().updateEntry(updatedEntry);
    _savedKey = updatedEntry.key; // Store the key that was actually saved

    // The navigation logic is now handled in the BlocListener
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: Text(
          widget.entryKey.isEmpty ? context.l10n.addEntry : context.l10n.editEntry(widget.entryKey),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocListener<LocalizationCubit, LocalizationState>(
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

              // Pop after successful save, but defer to next frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(
                  context,
                ).pop(SessionKey(key: _savedKey!, status: widget.initialStatus));
              });
            } else if (state is LocalizationError) {
              // Dismiss the saving snackbar
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              _currentSnackBar = null;

              ErrorDialog.show(context, state.message, error: null);
            }
          },
          child: _isLoadingLocales
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (widget.entryKey.isEmpty) // Show key input only for new entries
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _keyController,
                          decoration: InputDecoration(
                            labelText: context.l10n.key,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ..._supportedLocales.map((locale) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _controllers[locale.languageCode],
                          decoration: InputDecoration(
                            labelText: '${locale.languageCode.toUpperCase()} ${context.l10n.translation}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
        ),
      ),
    );
  }
}
