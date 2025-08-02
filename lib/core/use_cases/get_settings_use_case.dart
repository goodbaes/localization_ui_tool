import 'package:localization_ui_tool/core/models/settings.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';

class GetSettingsUseCase {
  GetSettingsUseCase(this.repo, this.directoryService);
  final SettingsRepository repo;
  final DirectoryService directoryService;
  Future<Settings> call() async {
    final savedLocale = await repo.locale;
    final savedThemeMode = await repo.themeMode;
    final savedFlexScheme = await repo.flexScheme;

    return Settings(
      directoryPath: directoryService.currentDirectoryPath,
      locale: savedLocale ?? 'en',
      themeMode: savedThemeMode ?? Settings().themeMode,
      flexScheme: savedFlexScheme ?? Settings().flexScheme,
    );
  }
}
