import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsRepository implements SettingsRepository {
  final SharedPreferences prefs;
  LocalSettingsRepository(this.prefs);

  @override
  Future<String?> get directoryPath => Future.value(prefs.getString('directoryPath'));
  @override
  Future<void> setDirectoryPath(String path) => prefs.setString('directoryPath', path);
  @override
  Future<bool> get autoSave => Future.value(prefs.getBool('autoSave') ?? false);
  @override
  Future<void> setAutoSave(bool value) => prefs.setBool('autoSave', value);
}
