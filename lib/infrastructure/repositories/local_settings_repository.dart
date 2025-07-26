import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this.prefs);
  final SharedPreferences prefs;

  @override
  Future<String?> get directoryPath => Future.value(prefs.getString('directoryPath'));
  @override
  Future<void> setDirectoryPath(String path) => prefs.setString('directoryPath', path);

  @override
  Future<Locale?> get locale async {
    final languageCode = prefs.getString('locale');
    if (languageCode == null) return null;
    return Locale(languageCode);
  }

  @override
  Future<void> setLocale(Locale locale) => prefs.setString('locale', locale.languageCode);

  @override
  Future<ThemeMode?> get themeMode async {
    final themeModeIndex = prefs.getInt('themeMode');
    if (themeModeIndex == null) return null;
    return ThemeMode.values[themeModeIndex];
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) => prefs.setInt('themeMode', themeMode.index);
}
