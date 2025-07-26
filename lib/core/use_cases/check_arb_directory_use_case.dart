import 'package:localization_ui_tool/infrastructure/repositories/arb_file_repository.dart';

class CheckArbDirectoryUseCase {
  CheckArbDirectoryUseCase(this.arbFileRepository);
  final ArbFileRepository arbFileRepository;

  Future<bool> call(String directoryPath) async {
    return ArbFileRepository.hasArbFiles(directoryPath);
  }
}
