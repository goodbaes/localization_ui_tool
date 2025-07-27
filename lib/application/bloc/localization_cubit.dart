import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/services/localization_service.dart';
import 'package:localization_ui_tool/core/use_cases/get_all_entries_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_entry_use_case.dart';

abstract class LocalizationState {}

class LocalizationInitial extends LocalizationState {}

class LocalizationLoading extends LocalizationState {}

class LocalizationSaving extends LocalizationState {}

class LocalizationLoaded extends LocalizationState {
  LocalizationLoaded(this.entries);
  final List<LocalizationEntry> entries;
}

class LocalizationError extends LocalizationState {
  LocalizationError(this.message, {this.error});
  final String message;
  final Object? error;
}

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit({
    required this.getAll,
    required this.saveEntry,
    required this.localizationService,
  }) : super(LocalizationInitial()) {
    loadEntries();
    localizationService.entriesStream.listen((entries) {
      if (entries.isEmpty) {
        if (state is LocalizationError) {
          return;
        }
        emit(LocalizationError('No entries found.'));
        return;
      }
      emit(LocalizationLoaded(entries));
    });
  }

  final LocalizationService localizationService;
  final GetAllEntriesUseCase getAll;
  final SaveEntryUseCase saveEntry;

  Future<void> loadEntries() async {
    try {
      emit(LocalizationLoading());
      await getAll();
    } catch (e) {
      emit(LocalizationError('Failed to load entries: $e'));
    }
  }

  Future<void> updateEntry(LocalizationEntry entry) async {
    try {
      emit(LocalizationSaving());
      await saveEntry(entry);
      await loadEntries(); // Reload entries after saving
    } catch (e) {
      emit(LocalizationError('Failed to save entry: $e', error: e));
    }
  }
}
