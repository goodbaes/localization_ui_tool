import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:localization_ui_tool/core/models/app_theme.dart';

abstract class SettingsRepository {
  Future<String?> get directoryPath;
  Future<void> setDirectoryPath(String? path);
  Future<String?> get locale;
  Future<void> setLocale(String locale);
  Future<AppTheme?> get themeMode;
  Future<void> setThemeMode(AppTheme themeMode);
  Future<FlexScheme?> get flexScheme;
  Future<void> setFlexScheme(FlexScheme flexScheme);
}
