import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';

class SaveSettingsUseCase {
  final SettingsRepository repo;
  SaveSettingsUseCase(this.repo);
  Future<void> call(Settings settings) async {
    if (settings.directoryPath != null) {
      await repo.setDirectoryPath(settings.directoryPath!);
    }
    await repo.setAutoSave(settings.autoSave);
  }
}
