abstract class SettingsRepository {
  Future<String?> get directoryPath;
  Future<void> setDirectoryPath(String path);
}
