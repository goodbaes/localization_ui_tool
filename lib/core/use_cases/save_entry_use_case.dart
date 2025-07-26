import 'package:localization_ui_tool/core/models/localization_entry.dart';
import 'package:localization_ui_tool/core/repositories/localization_repository.dart';

class SaveEntryUseCase {
  SaveEntryUseCase(this.repo);
  final LocalizationRepository repo;
  Future<void> call(LocalizationEntry entry) async {
    // валидация ключа, проверка коллизий
    await repo.saveEntry(entry);
  }
}
