import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

abstract class SettingsRepository {
  Future<String?> get directoryPath;
  Future<void> setDirectoryPath(String path);
  Future<Locale?> get locale;
  Future<void> setLocale(Locale locale);
  Future<ThemeMode?> get themeMode;
  Future<void> setThemeMode(ThemeMode themeMode);
  Future<FlexScheme?> get flexScheme;
  Future<void> setFlexScheme(FlexScheme flexScheme);
}
