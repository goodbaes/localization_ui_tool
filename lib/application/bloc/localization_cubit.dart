import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/use_cases/get_all_entries_use_case.dart';
import 'package:localization_ui_tool/core/use_cases/save_entry_use_case.dart';

abstract class LocalizationState {}

class LocalizationInitial extends LocalizationState {}

class LocalizationLoading extends LocalizationState {}

class LocalizationSaving extends LocalizationState {}

class LocalizationLoaded extends LocalizationState {
  final List<LocalizationEntry> entries;
  LocalizationLoaded(this.entries);
}

class LocalizationError extends LocalizationState {
  final String message;
  LocalizationError(this.message);
}

class LocalizationCubit extends Cubit<LocalizationState> {
  final GetAllEntriesUseCase getAll;
  final SaveEntryUseCase saveEntry;
  LocalizationCubit({required this.getAll, required this.saveEntry}) : super(LocalizationInitial());

  Future<void> loadEntries() async {
    try {
      emit(LocalizationLoading());
      final list = await getAll();
      emit(LocalizationLoaded(list));
    } catch (e) {
      emit(LocalizationError('Failed to load entries: ${e.toString()}'));
    }
  }

  Future<void> updateEntry(LocalizationEntry entry) async {
    try {
      emit(LocalizationSaving());
      await saveEntry(entry);
      await loadEntries(); // Reload entries after saving
    } catch (e) {
      emit(LocalizationError('Failed to save entry: ${e.toString()}'));
    }
  }
}