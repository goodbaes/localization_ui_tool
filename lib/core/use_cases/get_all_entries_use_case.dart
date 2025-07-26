import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';

class GetAllEntriesUseCase {
  final LocalizationRepository repo;
  GetAllEntriesUseCase(this.repo);
  Future<List<LocalizationEntry>> call() => repo.loadAll();
}
