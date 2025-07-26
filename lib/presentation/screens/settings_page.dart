import 'package:file_picker/file_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_supported_locales_use_case.dart';
import 'package:localization_ui_tool/l10n/arb/app_localizations.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';
import 'package:localization_ui_tool/presentation/widgets/error_dialog.dart';
import 'package:path/path.dart' as p;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Locale> _supportedLocales = [];
  bool _isLoadingLocales = true;

  @override
  void initState() {
    super.initState();
    _loadSupportedLocales();
  }

  Future<void> _loadSupportedLocales() async {
    try {
      final getSupportedLocales = GetIt.instance<GetSupportedLocalesUseCase>();
      final locales = await getSupportedLocales();
      setState(() {
        _supportedLocales = locales;
        _isLoadingLocales = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocales = false;
      });
      ErrorDialog.show(context, 'Failed to load locales: $e', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).colorScheme.surface);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocConsumer<SettingsCubit, SettingsState>(
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
                            final normalizedPath = p.normalize(p.absolute(selectedDirectory));
                            final hasArb = await context.read<SettingsCubit>().checkArbDirectory(normalizedPath);
                            if (!hasArb) {
                              ErrorDialog.show(context, context.l10n.noArbFilesFound, error: null);
                              return;
                            }
                            context.read<SettingsCubit>().update(
                              Settings(
                                directoryPath: normalizedPath,
                                locale: state.settings.locale,
                                themeMode: state.settings.themeMode,
                                flexScheme: state.settings.flexScheme,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(context.l10n.language),
                      trailing: _isLoadingLocales
                          ? const CircularProgressIndicator()
                          : DropdownButton<Locale>(
                              value: state.settings.locale ?? _supportedLocales.firstOrNull,
                              onChanged: (Locale? newLocale) {
                                if (newLocale != null) {
                                  context.read<SettingsCubit>().updateLocale(newLocale);
                                }
                              },
                              items: _supportedLocales.map<DropdownMenuItem<Locale>>((
                                Locale locale,
                              ) {
                                return DropdownMenuItem<Locale>(
                                  value: locale,
                                  child: Text(locale.languageCode),
                                );
                              }).toList(),
                            ),
                    ),
                    ListTile(
                      title: const Text('Theme Mode'), // TODO: Localize this string
                      trailing: DropdownButton<ThemeMode>(
                        value: state.settings.themeMode ?? ThemeMode.system,
                        onChanged: (ThemeMode? newThemeMode) {
                          if (newThemeMode != null) {
                            context.read<SettingsCubit>().updateThemeMode(newThemeMode);
                          }
                        },
                        items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>((
                          ThemeMode themeMode,
                        ) {
                          return DropdownMenuItem<ThemeMode>(
                            value: themeMode,
                            child: Text(themeMode.toString().split('.').last), // Display enum name
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: const Text('Theme Color Scheme'), // TODO: Localize this string
                      trailing: DropdownButton<FlexScheme>(
                        value: state.settings.flexScheme ?? FlexScheme.material,
                        onChanged: (FlexScheme? newFlexScheme) {
                          if (newFlexScheme != null) {
                            context.read<SettingsCubit>().updateFlexScheme(newFlexScheme);
                          }
                        },
                        items: FlexScheme.values.map<DropdownMenuItem<FlexScheme>>((
                          FlexScheme flexScheme,
                        ) {
                          return DropdownMenuItem<FlexScheme>(
                            value: flexScheme,
                            child: Text(flexScheme.toString().split('.').last), // Display enum name
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
      ),
    );
  }
}
