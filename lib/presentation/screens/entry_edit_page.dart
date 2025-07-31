import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/models/session_key.dart';
import 'package:localization_ui_tool/core/use_cases/get_supported_locales_use_case.dart';
import 'package:localization_ui_tool/core/utils/arb_validator.dart';
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
  late TextEditingController _keyController;
  bool _showLocalizationFields = false;
  List<Locale> _supportedLocales = [];
  bool _isLoading = false;
  String? _savedKey;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.entryKey);
    if (widget.entryKey.isNotEmpty) {
      _loadInitialData();
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final getSupportedLocales = GetIt.instance<GetSupportedLocalesUseCase>();
      final locales = await getSupportedLocales();
      _supportedLocales = locales;

      final state = context.read<LocalizationCubit>().state;
      if (state is LocalizationLoaded) {
        final existingEntry = state.entries.firstWhere(
          (entry) => entry.key == widget.entryKey,
          orElse: () => LocalizationEntry(key: widget.entryKey, values: {}),
        );

        for (final locale in _supportedLocales) {
          _controllers[locale.languageCode] = TextEditingController(text: existingEntry.values[locale.languageCode] ?? '');
        }
      }

      setState(() {
        _showLocalizationFields = true;
      });
    } catch (e) {
      ErrorDialog.show(context, 'Failed to load data: $e', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkKeyAndLoadLocales() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      ErrorDialog.show(context, 'Key cannot be empty');
      return;
    }

    setState(() {
      _isLoading = true;
      _showLocalizationFields = false;
    });

    try {
      final getSupportedLocales = GetIt.instance<GetSupportedLocalesUseCase>();
      final locales = await getSupportedLocales();
      _supportedLocales = locales;

      for (final locale in _supportedLocales) {
        _controllers[locale.languageCode] = TextEditingController();
      }

      setState(() {
        _showLocalizationFields = true;
      });
    } catch (e) {
      ErrorDialog.show(context, 'Failed to load locales: $e', error: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveEntry() async {
    final keyToSave = _keyController.text.trim();
    final keyValidationError = ArbValidator.validateKey(context, keyToSave);
    if (keyValidationError != null) {
      ErrorDialog.show(context, keyValidationError);
      return;
    }

    final updatedValues = <String, String>{};
    for (final locale in _supportedLocales) {
      final value = _controllers[locale.languageCode]?.text ?? '';
      final valueValidationError = ArbValidator.validateValue(context, value);
      if (valueValidationError != null) {
        ErrorDialog.show(context, '${locale.languageCode.toUpperCase()}: $valueValidationError');
        return;
      }
      updatedValues[locale.languageCode] = value;
    }

    final updatedEntry = LocalizationEntry(
      key: keyToSave,
      values: updatedValues,
    );

    await context.read<LocalizationCubit>().updateEntry(updatedEntry);
    _savedKey = updatedEntry.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryKey.isEmpty ? context.l10n.addEntry : context.l10n.editEntry(widget.entryKey)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _showLocalizationFields ? _saveEntry : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<LocalizationCubit, LocalizationState>(
          listener: (context, state) {
            if (state is LocalizationLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _savedKey != null) {
                  Navigator.of(context).pop(SessionKey(key: _savedKey!, status: widget.initialStatus));
                }
              });
            } else if (state is LocalizationError) {
              ErrorDialog.show(context, state.message);
            }
          },
          child: Column(
            children: [
              TextField(
                controller: _keyController,
                decoration: InputDecoration(
                  labelText: context.l10n.key,
                  border: const OutlineInputBorder(),
                ),
                readOnly: widget.entryKey.isNotEmpty,
              ),
              if (widget.entryKey.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkKeyAndLoadLocales,
                    child: Text(_isLoading ? 'Loading...' : 'Load Locales'),
                  ),
                ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              if (_showLocalizationFields)
                Expanded(
                  child: ListView(
                    children: _supportedLocales.map((locale) {
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
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
