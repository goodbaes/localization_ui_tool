import 'package:localization_ui_tool/core/models/settings.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';



class GetSettingsUseCase {
  GetSettingsUseCase(this.repo, this.directoryService);
  final SettingsRepository repo;
  final DirectoryService directoryService;
  Future<Settings> call() async {
    return Settings(
      directoryPath: directoryService.currentDirectoryPath,
      locale: await repo.locale,
      themeMode: await repo.themeMode,
      flexScheme: await repo.flexScheme,
    );
  }
}
