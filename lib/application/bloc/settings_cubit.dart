import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_settings_use_case.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  SettingsLoaded(this.settings);
  final Settings settings;
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.getSettings, required this.saveSettings}) : super(SettingsInitial());
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;

  Future<void> load() async {
    final settings = await getSettings();
    emit(SettingsLoaded(settings));
  }

  Future<void> update(Settings settings) async {
    await saveSettings(settings);
    emit(SettingsLoaded(settings));
  }

  Future<void> updateLocale(Locale locale) async {
    final currentSettings = (state as SettingsLoaded).settings;
    final updatedSettings = currentSettings.copyWith(locale: locale);
    await saveSettings(updatedSettings);
    emit(SettingsLoaded(updatedSettings));
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final currentSettings = (state as SettingsLoaded).settings;
    final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
    await saveSettings(updatedSettings);
    emit(SettingsLoaded(updatedSettings));
  }
}
