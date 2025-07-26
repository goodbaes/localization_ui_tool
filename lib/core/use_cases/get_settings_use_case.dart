import 'package:localization_ui_tool/core/repositories/settings_repository.dart';

class Settings {
  final String? directoryPath;
  final bool autoSave;

  Settings({required this.directoryPath, required this.autoSave});
}

class GetSettingsUseCase {
  final SettingsRepository repo;
  GetSettingsUseCase(this.repo);
  Future<Settings> call() async {
    return Settings(
      directoryPath: await repo.directoryPath,
      autoSave: await repo.autoSave,
    );
  }
}
