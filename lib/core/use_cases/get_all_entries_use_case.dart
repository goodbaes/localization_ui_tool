import 'package:localization_ui_tool/core/services/localization_service.dart';

class GetAllEntriesUseCase {
  GetAllEntriesUseCase(this.service);
  final LocalizationService service;
  Future<void> call() => service.loadAll();
}
