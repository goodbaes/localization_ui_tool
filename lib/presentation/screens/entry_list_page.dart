import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';

class EntryListPage extends StatelessWidget {
  const EntryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: context.l10n.search,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      // TODO: Implement search functionality
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.entries.length,
                    itemBuilder: (context, index) {
                      final entry = state.entries[index];
                      return ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.values.values.join(', ')),
                        onTap: () => context.push('/edit/${entry.key}'), // Changed from go to push
                      );
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add_entry');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
