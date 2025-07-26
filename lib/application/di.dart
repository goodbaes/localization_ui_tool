import 'package:get_it/get_it.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/use_cases/get_all_entries_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_entry_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_settings_use_case.dart';
import 'package:localization_ui_tool/infrastructure/models/arb_parser.dart';
import 'package:localization_ui_tool/infrastructure/repositories/arb_file_repository.dart';
import 'package:localization_ui_tool/infrastructure/repositories/local_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SettingsRepository>(LocalSettingsRepository(prefs));
  getIt.registerSingleton<ArbParser>(ArbParser());

  // Register LocalizationRepository as a LazySingleton, passing the Future<String?>
  getIt.registerLazySingleton<LocalizationRepository>(() {
    final settingsRepo = getIt<SettingsRepository>();
    return ArbFileRepository(
      directoryPathFuture: settingsRepo.directoryPath,
      parser: getIt<ArbParser>(),
    );
  });

  // Use cases
  getIt.registerLazySingleton(() => GetAllEntriesUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveEntryUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveSettingsUseCase(getIt()));
}
