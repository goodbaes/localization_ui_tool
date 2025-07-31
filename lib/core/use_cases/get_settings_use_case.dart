import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';

class Settings {
  Settings({
    this.directoryPath,
    this.locale,
    this.themeMode,
    this.flexScheme,
  });
  final String? directoryPath;
  final Locale? locale;
  final ThemeMode? themeMode;
  final FlexScheme? flexScheme;

  Settings copyWith({
    String? directoryPath,
    Locale? locale,
    ThemeMode? themeMode,
    FlexScheme? flexScheme,
  }) {
    return Settings(
      directoryPath: directoryPath ?? this.directoryPath,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      flexScheme: flexScheme ?? this.flexScheme,
    );
  }
}

class GetSettingsUseCase {
  GetSettingsUseCase(this.repo, this.directoryService);
  final SettingsRepository repo;
  final DirectoryService directoryService;
  Future<Settings> call() async {
    return Settings(
      directoryPath: directoryService.currentDirectoryPath,
      locale: await repo.locale,
      themeMode: await repo.themeMode,
      flexScheme: await repo.flexScheme,
    );
  }
}
