import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:localization_ui_tool/core/models/app_theme.dart';

class Settings {
  Settings({
    this.directoryPath,
    this.locale = 'en',
    this.themeMode = AppTheme.system,
    this.flexScheme = FlexScheme.material,
  });
  final String? directoryPath;
  final String locale;
  final AppTheme themeMode;
  final FlexScheme flexScheme;

  Settings copyWith({
    String? directoryPath,
    String? locale,
    AppTheme? themeMode,
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
