import 'package:localization_ui_tool/core/repositories/localization_repository.dart';

class CheckArbDirectoryUseCase {
  CheckArbDirectoryUseCase(this.arbFileRepository);
  final LocalizationRepository arbFileRepository;

  // This use case is a simple wrapper around the repository. 
  // It's kept for architectural consistency.
  Future<bool> call(String directoryPath) async {
    return arbFileRepository.hasArbFiles(directoryPath);
  }
}
