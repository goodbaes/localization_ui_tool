import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/models/session_key.dart';
import 'package:localization_ui_tool/core/utils/arb_validator.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';
import 'package:localization_ui_tool/presentation/widgets/error_dialog.dart';

class EntryListPage extends StatefulWidget {
  const EntryListPage({super.key});

  @override
  State<EntryListPage> createState() => _EntryListPageState();
}

class _EntryListPageState extends State<EntryListPage> {
  final TextEditingController _newKeyController = TextEditingController();
  final List<SessionKey> _sessionAddedKeys = [];
  String? _collidedKey;

  @override
  void dispose() {
    _newKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLoaded) {
          context.read<LocalizationCubit>().loadEntries();
        }
      },
      child: BlocListener<LocalizationCubit, LocalizationState>(
        listener: (context, state) {
          if (state is LocalizationLoaded) {
            setState(() {
              _sessionAddedKeys.clear();
              _collidedKey = null;
              _newKeyController.clear();
            });
          } else if (state is LocalizationError) {
            ErrorDialog.show(context, state.message, error: state.error);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(context.l10n.appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.push('/settings');
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: BlocBuilder<LocalizationCubit, LocalizationState>(
              builder: (context, state) {
                if (state is LocalizationInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LocalizationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LocalizationLoaded) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _newKeyController,
                                decoration: InputDecoration(
                                  labelText: context.l10n.newKey,
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _newKeyController.clear();
                                      setState(() {
                                        _collidedKey = null;
                                      });
                                    },
                                  ),
                                ),
                                onSubmitted: (value) => _handleAddKey(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _handleAddKey,
                              child: SizedBox(
                                height: 50,
                                width: 100,
                                child: Center(child: Text(context.l10n.add)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_collidedKey != null)
                        ListTile(
                          title: Text(
                            '${String.fromCharCode(0x21AA)} ${context.l10n.keyExists}: $_collidedKey',
                            style: const TextStyle(color: Colors.red),
                          ),
                          onTap: () => context.push(
                            '/edit/$_collidedKey',
                            extra: SessionKeyStatus.modifiedKey,
                          ),
                        ),
                      if (_sessionAddedKeys.isNotEmpty)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  context.l10n.sessionAddedKeys,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _sessionAddedKeys.length,
                                  itemBuilder: (context, index) {
                                    final sessionKey = _sessionAddedKeys[index];
                                    return ListTile(
                                      leading: Text(String.fromCharCode(0x2714)),
                                      title: Text(sessionKey.key),
                                      onTap: () => context.push(
                                        '/edit/${sessionKey.key}',
                                        extra: sessionKey.status,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                    ],
                  );
                } else if (state is LocalizationSaving) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.read<SettingsCubit>().selectDirectory(),

                        child: Text(context.l10n.entryListOpenFolder),
                      ),
                      Text(context.l10n.errorLoadingEntries),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddKey() async {
    final newKey = _newKeyController.text.trim();
    final validationError = ArbValidator.validateKey(context, newKey);
    if (validationError != null) {
      ErrorDialog.show(context, validationError);
      return;
    }
    if (newKey.isNotEmpty) {
      final existingEntry = (context.read<LocalizationCubit>().state as LocalizationLoaded).entries
          .firstWhere(
            (entry) => entry.key == newKey,
            orElse: () => const LocalizationEntry(key: '', values: {}),
          );

      if (existingEntry.key.isNotEmpty) {
        // Key exists, show only this entry and highlight collision
        setState(() {
          _collidedKey = newKey;
          _newKeyController.clear();
        });
      } else {
        // Key does not exist, navigate to add new entry
        final result = await context.push(
          '/edit/$newKey',
          extra: SessionKeyStatus.newKey,
        );
        if (result is SessionKey) {
          setState(() {
            // Remove if already exists (e.g., if it was modified from new to modified)
            _sessionAddedKeys.removeWhere(
              (element) => element.key == result.key,
            );
            _sessionAddedKeys.add(result);
          });
        }
        setState(() {
          _collidedKey = null; // Clear collision highlight
          _newKeyController.clear();
        });
      }
    }
  }
}
