import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';

class GetAllEntriesUseCase {
  GetAllEntriesUseCase(this.repo);
  final LocalizationRepository repo;
  Future<List<LocalizationEntry>> call() => repo.loadAll();
}
