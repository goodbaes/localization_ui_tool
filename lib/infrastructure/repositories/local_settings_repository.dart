import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this.prefs);
  final SharedPreferences prefs;

  @override
  Future<String?> get directoryPath {
    final path = prefs.getString('directoryPath');
    debugPrint('LocalSettingsRepository: Reading directoryPath: $path');
    return Future.value(path);
  }
  @override
  Future<void> setDirectoryPath(String path) {
    debugPrint('LocalSettingsRepository: Saving directoryPath: $path');
    return prefs.setString('directoryPath', path);
  }

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

  @override
  Future<FlexScheme?> get flexScheme async {
    final schemeName = prefs.getString('flexScheme');
    if (schemeName == null) return null;
    return FlexScheme.values.firstWhere(
      (e) => e.toString() == 'FlexScheme.$schemeName',
      orElse: () => FlexScheme.material,
    );
  }

  @override
  Future<void> setFlexScheme(FlexScheme flexScheme) => prefs.setString('flexScheme', flexScheme.name);
}
