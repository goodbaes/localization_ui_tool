import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
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
  final List<String> _sessionAddedKeys = [];
  String? _collidedKey;

  @override
  void dispose() {
    _newKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          if (state is LocalizationInitial) {
            context.read<LocalizationCubit>().loadEntries();
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
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final newKey = _newKeyController.text.trim();
                          final validationError = ArbValidator.validateKey(newKey);
                          if (validationError != null) {
                            ErrorDialog.show(context, validationError);
                            return;
                          }
                          if (newKey.isNotEmpty) {
                            final existingEntry = state.entries.firstWhere(
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
                              context.push('/edit/$newKey');
                              setState(() {
                                _sessionAddedKeys.add(newKey);
                                _collidedKey = null; // Clear collision highlight
                                _newKeyController.clear();
                              });
                            }
                          }
                        },
                        child: Text(context.l10n.add),
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
                    onTap: () => context.push('/edit/$_collidedKey'),
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
                              final key = _sessionAddedKeys[index];
                              return ListTile(
                                title: Text(key),
                                onTap: () => context.push('/edit/$key'),
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
          return Center(child: Text(context.l10n.errorLoadingEntries));
        },
      ),
    );
  }
}
