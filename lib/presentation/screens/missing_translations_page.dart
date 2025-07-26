import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';

class MissingTranslationsPage extends StatelessWidget {
  const MissingTranslationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: Text(context.l10n.missingTranslations),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<LocalizationCubit, LocalizationState>(
          builder: (context, state) {
            if (state is LocalizationInitial || state is LocalizationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LocalizationLoaded) {
              final missingEntries = state.entries.where((entry) {
                // Assuming we have a list of all supported locales
                // For now, let's just check if any value is empty
                return entry.values.containsValue('') ||
                    entry.values.length < 2; // Assuming at least 2 locales (en, es)
              }).toList();

              if (missingEntries.isEmpty) {
                return Center(child: Text(context.l10n.noMissingTranslations));
              }

              return ListView.builder(
                itemCount: missingEntries.length,
                itemBuilder: (context, index) {
                  final entry = missingEntries[index];
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      entry.values.entries
                          .map((e) => '${e.key}: ${e.value.isEmpty ? '[MISSING]' : e.value}')
                          .join(', '),
                    ),
                    // You might want to add onTap to navigate to edit page
                  );
                },
              );
            }
            return Center(child: Text(context.l10n.errorLoadingEntries));
          },
        ),
      ),
    );
  }
}
