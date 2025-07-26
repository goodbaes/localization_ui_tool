import 'package:get_it/get_it.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';
import 'package:localization_ui_tool/core/use_cases/check_arb_directory_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_all_entries_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_entry_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_supported_locales_use_case.dart';
import 'package:localization_ui_tool/infrastructure/models/arb_parser.dart';
import 'package:localization_ui_tool/infrastructure/repositories/arb_file_repository.dart';
import 'package:localization_ui_tool/infrastructure/repositories/local_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDI() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SettingsRepository>(LocalSettingsRepository(prefs));
  getIt.registerSingleton<DirectoryService>(DirectoryService(getIt<SettingsRepository>()));
  getIt.registerSingleton<ArbParser>(ArbParser());

  getIt.registerLazySingleton<LocalizationRepository>(() {
    return ArbFileRepository(
      settingsRepository: getIt<SettingsRepository>(),
      parser: getIt<ArbParser>(),
    );
  });

  // Use cases
  getIt.registerLazySingleton(() => GetAllEntriesUseCase(getIt<LocalizationRepository>()));
  getIt.registerLazySingleton(() => SaveEntryUseCase(getIt<LocalizationRepository>()));
  getIt.registerLazySingleton(
    () => GetSettingsUseCase(getIt<SettingsRepository>(), getIt<DirectoryService>()),
  );
  getIt.registerLazySingleton(
    () => SaveSettingsUseCase(getIt<SettingsRepository>(), getIt<DirectoryService>()),
  );
  getIt.registerLazySingleton(
    () => CheckArbDirectoryUseCase(getIt<LocalizationRepository>() as ArbFileRepository),
  );
  getIt.registerLazySingleton(() => GetSupportedLocalesUseCase(getIt<LocalizationRepository>()));

  // Cubits
  getIt.registerFactory(
    () => LocalizationCubit(
      getAll: getIt<GetAllEntriesUseCase>(),
      saveEntry: getIt<SaveEntryUseCase>(),
      directoryService: getIt<DirectoryService>(),
    ),
  );
  getIt.registerFactory(
    () => SettingsCubit(
      getSettings: getIt<GetSettingsUseCase>(),
      saveSettings: getIt<SaveSettingsUseCase>(),
      directoryService: getIt<DirectoryService>(),
      checkArbDirectoryUseCase: getIt<CheckArbDirectoryUseCase>(),
    ),
  );
}
