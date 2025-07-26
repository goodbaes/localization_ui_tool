import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_settings_use_case.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;
  SettingsLoaded(this.settings);
}

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettings;
  final SaveSettingsUseCase saveSettings;
  SettingsCubit({required this.getSettings, required this.saveSettings}) : super(SettingsInitial());

  Future<void> load() async {
    final settings = await getSettings();
    emit(SettingsLoaded(settings));
  }

  Future<void> update(Settings settings) async {
    await saveSettings(settings);
    emit(SettingsLoaded(settings));
  }
}
