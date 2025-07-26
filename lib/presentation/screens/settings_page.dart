import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/l10n/arb/app_localizations.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // No longer showing a toast for settings saved.
        },
        builder: (context, state) {
          if (state is SettingsInitial) {
            context.read<SettingsCubit>().load();
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(context.l10n.arbDirectory),
                    subtitle: Text(state.settings.directoryPath ?? context.l10n.notSet),
                    trailing: IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () async {
                        final selectedDirectory = await FilePicker.platform.getDirectoryPath();
                        if (selectedDirectory != null) {
                          context.read<SettingsCubit>().update(
                            Settings(
                              directoryPath: selectedDirectory,
                              locale: state.settings.locale,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(context.l10n.language),
                    trailing: DropdownButton<Locale>(
                      value: Localizations.localeOf(context),
                      onChanged: (Locale? newLocale) {
                        if (newLocale != null) {
                          context.read<SettingsCubit>().updateLocale(newLocale);
                        }
                      },
                      items: AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>((Locale locale) {
                        return DropdownMenuItem<Locale>(
                          value: locale,
                          child: Text(locale.languageCode),
                        );
                      }).toList(),
                    ),
                  ),
                  ListTile(
                    title: Text('Theme'), // TODO: Localize this string
                    trailing: DropdownButton<ThemeMode>(
                      value: state.settings.themeMode ?? ThemeMode.system,
                      onChanged: (ThemeMode? newThemeMode) {
                        if (newThemeMode != null) {
                          context.read<SettingsCubit>().updateThemeMode(newThemeMode);
                        }
                      },
                      items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>((ThemeMode themeMode) {
                        return DropdownMenuItem<ThemeMode>(
                          value: themeMode,
                          child: Text(themeMode.toString().split('.').last), // Display enum name
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text(context.l10n.errorLoadingEntries));
        },
      ),
    );
  }
}
