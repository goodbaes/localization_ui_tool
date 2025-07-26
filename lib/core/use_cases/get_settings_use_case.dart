import 'package:localization_ui_tool/core/repositories/settings_repository.dart';

import 'package:flutter/material.dart';

class Settings {
  Settings({
    this.directoryPath,
    this.locale,
    this.themeMode,
  });
  final String? directoryPath;
  final Locale? locale;
  final ThemeMode? themeMode;

  Settings copyWith({
    String? directoryPath,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return Settings(
      directoryPath: directoryPath ?? this.directoryPath,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class GetSettingsUseCase {
  GetSettingsUseCase(this.repo);
  final SettingsRepository repo;
  Future<Settings> call() async {
    return Settings(
      directoryPath: await repo.directoryPath,
      locale: await repo.locale,
      themeMode: await repo.themeMode,
    );
  }
}
