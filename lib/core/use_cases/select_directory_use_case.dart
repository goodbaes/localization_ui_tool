import 'package:localization_ui_tool/core/services/directory_service.dart';

class SelectDirectoryUseCase {
  SelectDirectoryUseCase(this._directoryService);
  final DirectoryService _directoryService;

  Future<String?> call() {
    return _directoryService.selectDirectory();
  }
}
