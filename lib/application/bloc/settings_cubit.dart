import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/core/errors/no_arb_files_found_exception.dart';
import 'package:localization_ui_tool/core/models/app_theme.dart';
import 'package:localization_ui_tool/core/models/settings.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';
import 'package:localization_ui_tool/core/use_cases/check_arb_directory_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/select_directory_use_case.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  SettingsLoaded(this.settings);
  final Settings settings;
}

class SettingsError extends SettingsState {
  SettingsError(this.message);
  final String message;
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.getSettings,
    required this.saveSettings,
    required this.directoryService,
    required this.checkArbDirectoryUseCase,
    required this.selectDirectoryUseCase,
  }) : super(SettingsInitial()) {
    directoryService.directoryPathStream.listen((path) {
      if (path != null && path.isNotEmpty) {
        load();
      } else {
        emit(SettingsError('Directory path is empty'));
        emit(SettingsInitial());
      }
    });
  }
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;
  final DirectoryService directoryService;
  final CheckArbDirectoryUseCase checkArbDirectoryUseCase;
  final SelectDirectoryUseCase selectDirectoryUseCase;

  Future<bool> checkArbDirectory(String path) async {
    return checkArbDirectoryUseCase(path);
  }

  Future<void> selectDirectory() async {
    try {
      final path = await selectDirectoryUseCase();
      if (path != null) {
        final currentSettings = (state as SettingsLoaded).settings;
        final updatedSettings = currentSettings.copyWith(directoryPath: path);
        await saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    } on NoArbFilesFoundException catch (e) {
      emit(SettingsError(e.message));
      emit(SettingsInitial());
    }
  }

  Future<void> load() async {
    final settings = await getSettings();
    emit(SettingsLoaded(settings));
  }

  Future<void> update(Settings settings) async {
    await saveSettings(settings);
    emit(SettingsLoaded(settings));
  }

  Future<void> updateLocale(String locale) async {
    final currentSettings = (state as SettingsLoaded).settings;
    final updatedSettings = currentSettings.copyWith(locale: locale);
    await saveSettings(updatedSettings);
    emit(SettingsLoaded(updatedSettings));
  }

  Future<void> updateThemeMode(AppTheme themeMode) async {
    final currentSettings = (state as SettingsLoaded).settings;
    final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
    await saveSettings(updatedSettings);
    emit(SettingsLoaded(updatedSettings));
  }

  Future<void> updateFlexScheme(FlexScheme flexScheme) async {
    final currentSettings = (state as SettingsLoaded).settings;
    final updatedSettings = currentSettings.copyWith(flexScheme: flexScheme);
    await saveSettings(updatedSettings);
    emit(SettingsLoaded(updatedSettings));
  }
}
