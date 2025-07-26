import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this.prefs);
  final SharedPreferences prefs;

  @override
  Future<String?> get directoryPath => Future.value(prefs.getString('directoryPath'));
  @override
  Future<void> setDirectoryPath(String path) => prefs.setString('directoryPath', path);
}
