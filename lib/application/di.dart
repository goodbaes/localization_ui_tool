import 'package:get_it/get_it.dart';
import 'package:localization_ui_tool/application/bloc/localization_cubit.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/data/datasource/directory_datasource.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';
import 'package:localization_ui_tool/core/repositories/settings_repository.dart';
import 'package:localization_ui_tool/core/services/directory_service.dart';
import 'package:localization_ui_tool/core/services/localization_service.dart';
import 'package:localization_ui_tool/core/use_cases/check_arb_directory_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_all_entries_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/get_supported_locales_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_entry_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/select_directory_use_case.dart';
import 'package:localization_ui_tool/infrastructure/datasource/file_picker_directory_datasource.dart';
import 'package:localization_ui_tool/infrastructure/models/arb_parser.dart';
import 'package:localization_ui_tool/infrastructure/repositories/arb_file_repository.dart';
import 'package:localization_ui_tool/infrastructure/repositories/local_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDI() async {
  final prefs = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SettingsRepository>(LocalSettingsRepository(prefs))
    ..registerSingleton<ArbParser>(ArbParser())
    ..registerSingleton<DirectoryDatasource>(FilePickerDirectoryDataSource())
    ..registerSingleton<DirectoryService>(
      DirectoryService(getIt<SettingsRepository>(), getIt<DirectoryDatasource>()),
    )
    ..registerLazySingleton<LocalizationRepository>(() {
      return ArbFileRepository(
        settingsRepository: getIt<SettingsRepository>(),
        parser: getIt<ArbParser>(),
      );
    })
    ..registerLazySingleton(() => LocalizationService(getIt<LocalizationRepository>()))
    // Use cases
    ..registerLazySingleton(() => GetAllEntriesUseCase(getIt()))
    ..registerLazySingleton(() => SaveEntryUseCase(getIt<LocalizationRepository>()))
    ..registerLazySingleton(
      () => GetSettingsUseCase(getIt<SettingsRepository>(), getIt<DirectoryService>()),
    )
    ..registerLazySingleton(
      () => SaveSettingsUseCase(getIt<SettingsRepository>(), getIt<DirectoryService>()),
    )
    ..registerLazySingleton(
      () => CheckArbDirectoryUseCase(getIt<LocalizationRepository>() as ArbFileRepository),
    )
    ..registerLazySingleton(() => GetSupportedLocalesUseCase(getIt<LocalizationRepository>()))
    ..registerLazySingleton(
      () => SelectDirectoryUseCase(
        getIt<DirectoryService>(),
      ),
    )
    // Cubits
    ..registerFactory(
      () => LocalizationCubit(
        getAll: getIt<GetAllEntriesUseCase>(),
        saveEntry: getIt<SaveEntryUseCase>(),
        localizationService: getIt<LocalizationService>(),
      ),
    )
    ..registerFactory(
      () => SettingsCubit(
        getSettings: getIt<GetSettingsUseCase>(),
        saveSettings: getIt<SaveSettingsUseCase>(),
        directoryService: getIt<DirectoryService>(),
        checkArbDirectoryUseCase: getIt<CheckArbDirectoryUseCase>(),
        selectDirectoryUseCase: getIt<SelectDirectoryUseCase>(),
      ),
    );
}
