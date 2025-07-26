abstract class SettingsRepository {
  Future<String?> get directoryPath;
  Future<void> setDirectoryPath(String path);
  Future<bool> get autoSave;
  Future<void> setAutoSave(bool value);
}
