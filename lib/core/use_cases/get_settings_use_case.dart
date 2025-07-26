import 'package:localization_ui_tool/core/repositories/settings_repository.dart';

class Settings {
  Settings({required this.directoryPath});
  final String? directoryPath;
}

class GetSettingsUseCase {
  GetSettingsUseCase(this.repo);
  final SettingsRepository repo;
  Future<Settings> call() async {
    return Settings(
      directoryPath: await repo.directoryPath,
    );
  }
}
