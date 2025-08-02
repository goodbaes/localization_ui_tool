import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';
import 'package:localization_ui_tool/core/models/settings.dart';

class SaveSettingsUseCase {
  SaveSettingsUseCase(this.repo, this.directoryService);
  final SettingsRepository repo;
  final DirectoryService directoryService;
  Future<void> call(Settings settings) async {
    await directoryService.setDirectoryPath(settings.directoryPath);
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
