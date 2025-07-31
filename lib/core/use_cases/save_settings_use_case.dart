import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';

class SaveSettingsUseCase {
  SaveSettingsUseCase(this.repo, this.directoryService);
  final SettingsRepository repo;
  final DirectoryService directoryService;
  Future<void> call(Settings settings) async {
    if (settings.directoryPath != null) {
      await directoryService.setDirectoryPath(settings.directoryPath);
    } else {
      await directoryService.setDirectoryPath(null);
    }
    if (settings.locale != null) {
      await repo.setLocale(settings.locale!);
    }
    if (settings.themeMode != null) {
      await repo.setThemeMode(settings.themeMode!);
    }
    if (settings.flexScheme != null) {
      await repo.setFlexScheme(settings.flexScheme!);
    }
  }
}
