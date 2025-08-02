import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/models/app_theme.dart';
import 'package:localization_ui_tool/l10n/arb/app_localizations.dart';
import 'package:localization_ui_tool/l10n/l10n.dart';
import 'package:localization_ui_tool/presentation/widgets/error_dialog.dart';

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
      const getSupportedLocales = AppLocalizations.supportedLocales;
      setState(() {
        _supportedLocales = getSupportedLocales;
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
            if (state is SettingsError) {
              ErrorDialog.show(context, state.message);
            }
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
                          await context.read<SettingsCubit>().selectDirectory();
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(context.l10n.language),
                      trailing: _isLoadingLocales
                          ? const CircularProgressIndicator()
                          : DropdownButton<String>(
                              value: state.settings.locale,
                              onChanged: (String? newLocale) {
                                if (newLocale != null) {
                                  context.read<SettingsCubit>().updateLocale(newLocale);
                                }
                              },
                              items: _supportedLocales.map<DropdownMenuItem<String>>((
                                Locale locale,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: locale.languageCode,
                                  child: Text(locale.languageCode),
                                );
                              }).toList(),
                            ),
                    ),
                    ListTile(
                      title: Text(context.l10n.settingsThemeMode),
                      trailing: DropdownButton<AppTheme>(
                        value: state.settings.themeMode,
                        onChanged: (AppTheme? newThemeMode) {
                          if (newThemeMode != null) {
                            context.read<SettingsCubit>().updateThemeMode(newThemeMode);
                          }
                        },
                        items: AppTheme.values.map<DropdownMenuItem<AppTheme>>((
                          AppTheme themeMode,
                        ) {
                          return DropdownMenuItem<AppTheme>(
                            value: themeMode,
                            child: Text(themeMode.toString().split('.').last), // Display enum name
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: Text(context.l10n.settingsThemeColorScheme),
                      trailing: DropdownButton<FlexScheme>(
                        value: state.settings.flexScheme,
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
